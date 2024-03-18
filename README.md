There are three trees.

SCENE TREE
Contains a mix of non-flattened groups of tris and SLRGs of tris.


1. Flatten the groups of tris
2. Sort the tris


SORT TREE
Contains a tree of sorted tris and SLRGs.


- Project the tris onto the screen
- Flatten the SLRGs


RENDER LIST
Contains a list of tris to be rendered.






1. Flatten groups of tris into just SLRGs
2. Sort the tris within SLRGs
3. - Project tris onto screen
   - Flatten the SLRGs



SORT TREE
- Consists only of nodes and SLRGs.
- The compute method sorts its children, expands them into a list, projects them onto the screen (as RenderTris) and returns the list.

Any other way of organising tris into groups and models can be implemented at a higher level, which then generates this tree.


But we also want a nice way of storing the previous frame's sorted tree to use to speed up sorting for this ones.

The nice thing about the separate trees is that the SortTree is then guaranteed to be sorted at all points in time. It is IMMUTABLE!

What if SortTree first produces a separate 'sort object' which is a tree of sorted keys? Too complicated.

So what's the issue with having lots of trees, each one generated as a single step of the way?
- Is there a proper order to do things in?
- Will there be too much duplicated information? (e.g. vertices)

1. First, the scene tree which can have whatever it likes. SLRGs, non-SLRG groups, tris, squares?!
2. Second, the SLRG and tri only tree
3. Third, the sorted SLRG and tri only tree
   - Can be used for the sorting the next frame
4. Fourth, the flattened list of tris
5. Fifth, the list of projected 2D tris

Or the SortTree does the sorting within the method (doesn't produce an immutable sorted tree) but also spits out a sorted key tree for comparison to next frame? Almost seems like the nicest solution, even though the key tree is kind arse.
|
But this key shit is another thing to change if the structure around the tree changes. If I were simply just passing the previous sorted frame, I would only need to make changes within that one class. But since I'm re-creating the structure its duplicated structure. If I were able to pass the previous tree then that would definitely be simplest.



A good idea is to have the tree be both immutable, but have a 'sorted' bool, perhaps only accessible internally.
|
So you call the method, it generates a new sorted immutable tree which it then passes on internally *and* returns to be used next frame.

A next question then is where does it receive the next frame from?






When it comes to sorting, tris will have relations to few other tris in the scene. So you will have a directed graph (a->b means a in front of b), with smaller groups of connected tris (SLRGs), some cycles, and some isolated tris.

Cycles are a natural limitation of this rendering style (unless you perform splitting), so we can simply remove some edges to make it a DAG.

Once you have a DAG, its an O(n) operation to order its elements.

However the expensive part here is not ordering the elements, but calculating the relations of the tris to produce the DAG. We want to minimise the number of tris we compare each tri to.

The bounding box trick will drastically reduce the cost of a single non-overlap comparison, but we still have n^2 comparisons total. How can we skip some comparisons? If we already have a transitive order, then no need. Right? We only need to compare each new tri (as we go through them sequentially), with all existing sub-graphs. It's like we are building up sub-graphs, with the end result being a set of sub-graphs which have no relation to each other. Any cycle-causing edges aren't there because the comparisons which would've caused them were skipped.
|
We can use the set-building data structure from algorithms here, to tell which tris are inside which sub-graphs quickly without traversal. This means a heavily connected scene actually renders faster?
|
The above assumption is not true. We cannot do a single comparison, but due to the acyclic and transitive rules some comparisons may allow us to skip more comparisons than others.

A \
B -> D -> E -> (F)
C /

               / C
(F) -> A -> B -> D
               \ E

For new tri F

On the end:
- The transitive rule. If E->F, no need to check ABCD->F because they're true transitively.
- Acyclic rule. If E->F, no need to check F->ABCD because even if any were true, we'd skip them to prevent cycles.

At the start:
- The transitive rule. If F->A, no need to check F->BCDE, because its true transitively.
- Acyclic rule. If F->A, no need to check BCDE->F, because they'd cause cycles.

If our tri is in front of a tri, we don't need to compare it to all tris in front of that tri. And vice versa. But this is a bit like a binary search in that you're most likely to be behind a tri at the front of the scene, and in front of a tri at the back, both of which don't skip (m)any other tris using our rules.
|
So we could do a binary search, starting at the middle, or we could use our previous frame like with the insertion sort. But how do we apply these sorts to DAGs with no total order?

So if we compare to a tri, 




Shading and lighting can be done with a modifier Item


---

We want to support both 3D tri operations, and 2D tri operations, like shaders. If we wanted to allow this, we can either support inserting custom code into the renderer, or we expect the user to do the several compilation steps themselves.

But wouldn't it be nice to be able to add shader effects within the scene view? How can we do that? Maybe there's a scene view item which lets you give it a function which takes in renderItems and returns new ones. Or they can insert canvas instructions?

We also want to support custom group types.

---

Currently works like this:

SceneItem (cube, plane)
| compile
v
ProcessItem (tri3D[]s, SLRGs)
| sort
| optimise
| compile
v
RenderItem (tri2D[])



People will want to make their own SceneItems, just like Widgets. You can do this currently. People will want to make their own ProcessItems to have custom sorting groups, and custom non-group ones for custom RenderItems like text?

Remember, a SceneItem group can either be a SLRG or just for organisation, but a ProcessItem group is a SLRG.

The issue is that the sorting algorithm needs guarantees that it can handle all types. And if you introduce a new group type, how can we guarantee it will work with all other types as best as possible (or at all)?

A new group can sort within itself no problem - it can do what it likes and this will work. But how do you sort between SLRGs arbitrarily?

Is the only solution to have a fallback? But then if one of the types has custom sorting algorithm for the pair of compared types it can be used.

How can custom non-group ProcessItems work, for custom RenderItems? The issue here is again with sorting against other ProcessItems.

! This is an issue.



People will also want custom RenderItems, or the ability to directly insert canvas instructions based on those RenderItems. It would be nice to be able to do this via SceneItems, such as an "Outline".

You could take one of two approaches. One is to only have RenderTris and custom functions. Then all custom RenderItems are just a function which operates on the behaviour of the RenderTri. The other is allow custom RenderItems.

The custom function would be most useful if RenderItems were sealed, as then you could guarantee the interface. But this means it's not extensible.

Ideally the RenderItem class roster matches the canvases full functionality. But I don't like this, as the interface is huge! Part of the charm of this rendering engine is the small graphical interface. Just tris (atm).

How would a LineRenderItem work? Perhaps we can have a point ProcessItem which is just used to see where it ends up post-projection. It can include a depth value perhaps. You could then build a shader-esque custom RenderItem for that.

Following this logic, the RenderTri could also be done this way. Maybe custom ProcessTri is actually just a set of points, which compiles to a custom RenderItem which uses those points however it likes. The only thing the rendering engine is providing then is a projection system.



With such a flexible system, what happens to ProcessItem sorting? We could go to the fallback method, but it's not ideal.

From these past several thought chains, I see two options. One, we keep a fixed ProcessItem and RenderItem class roster. It guarantees stability. Two, we allow custom for both. Maybe we can add assertions about type, or throw an error if a comparison between two unexpected types occurs. This means that if a fallback is used, its a conscious decision by the programmer.

Does the second option allow adding shaders on top of existing RenderItems? A SceneItem shader would get back a list of ProcessItems. It would need to give back a ProcessItem, so would give back a shader ProcessItem which wraps its child ProcessItem. Then when the shader ProcessItem is compiled, it receives the wrapped RenderItems. The issue here is that the RenderItem is not a common interface, it can be whatever.

! If we're going to allow shader stuff, we need a fixed RenderItem interface.

Could LineRenderItem could be implemented as a shader? It would be tacked on top of a tri. So it would probably need to be one of the few sealed RenderItem classes.



So how are shaders implemented with fixed RenderItems? Maybe its a RenderItemGroup class which you can pass a callback function to? It passes the callback the set of RenderItems inside the group (which you'll probably call render for each).

I'm hesitant to create a tree structure to the RenderItems, but it seems necessary. The effect shader function would not want to deal with a tree of RenderItems as its argument. It doesn't care about what other effects have already been added. So, it should flatten its children and pass that upwards to the next effect.

! Do we have to allow a shader to both get its flattened children, and then render a shader child in one go?

No automatic flattening. If a parent shader wants to operate on a child shader, then it must decide what to do (either traverse *its* children or ignore).



Following this, do we actually need custom ProcessItems? With fixed 3D RenderTris, we can have fixed non-group ProcessItems for each. The main question is if we can exhaustively create all ProcessItemGroups we'd need? The main reason for different groups is speed of sorting and optimisation. If we can create all the types of groups we could need, then we should be okay.

I.e. a generic mesh group, a convex hull mesh. If we can create all the ones we need, then we don't have to worry about custom sorting stuff at all, which is really nice.

! So, can we create all we would ever need?

In terms of improving over time, I think it would be okay. The API would only grow so no breaking changes. I think the main issue is if users are hugely limited because they can't implement their own custom one. But it seems unlikely.

Maybe best course of action is to make it limited for now, but can always open up in the future before full library release.

---

Next Steps
-[x] Add basic keys for debugging
-[x] Reduce false order dependency. Require slight overlap with epsilon value with tri intersect plane check.
-[x] Fix topological sort by starting with no-parent nodes.
-[x] Add co-planar check to parallel tris, and return no-order.
-[x] Fix null error when tris cross camera plane
-[x] Fix camera rotation
-[ ] Check performance breakdown
-[ ] Do obscure check to delete more tris.
-[ ] Fix ShadeItem
-[ ] Fix / make sense of flipped vertical axis
-[ ] Load STL file
-[ ] Make sorting more stable by using keys when no-order.
-[ ] Shaders need to be able to draw whenever in rendering process. E.g. an outline shader needs to draw at end. Make sure this is possible.
-[ ] Add click detection. Insert a SceneItem which internally generates a clickable RenderItem. Triggers callback, with mouse coordinates, and maybe 3D coordinate of intersection with clicked RenderItem.
-[ ] Debug with keys. Improve keys. Make the key passing on compilation automatic? Keys may not be needed for sorting given its with a DAG, so they become purely for debugging, and therefore completely optional?
-[ ] Add convenience parameters to SceneItem (SRT, debug info)
-[ ] For each RenderItem render function, make it save and restore canvas state. (think things like clipRect).
-[ ] Check cube face orientation generation with debug labels.
-[ ] Fix camera fov (should it be fixed?)
-[ ] Support canvas.saveLayer in shaders
-[ ] Support custom tri normals?
-[ ] View frustum culling.
-[ ] Function to load in mesh files and automatically group them together into convex hulls for more efficient rendering. Should also auto-split intersecting tris.
-[ ] Live split tris which intersect.
-[ ] Split functionality into libraries
  - Sorting as graph library
  - Rendering
    - Camera & projection
    - SceneItems
    - ProcessItems
    - RenderItems
  - Flutter specific (e.g. APIs over Canvas and Color; CustomPaint(er);)
-[ ] Re-introduce Scene class to store items?