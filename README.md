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