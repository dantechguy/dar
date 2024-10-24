DESIGN (1)

WRITE TESTS (2)

IMPLEMENT (3)

INBOX
- [ ] Fix project!! Copy lib folder into new project
- [ ] Change library name to 'ren'.
- [ ] DrenderLayer doesn't allow transformations.
- [ ] Check performance breakdown
    - Most is in the bounding check.
    - Pre-compute inverse rotation quaternion.
    - Is it better to check for precise triangle overlapping?
    - Perhaps if the square boundary check fails.
    - Optimise common functions in flame chart
    - Minimising sorting is essential. 90% of time is sorting.
- [ ] Do obscure check to delete more tris.
    - Use https://stackoverflow.com/a/2049593/9063935
    - In this case it's useful to test with closest tris first. Use previous tree sorting to decide order of this test?
- [ ] Fix ShadeItem
- [ ] Fix / make sense of flipped vertical axis
- [ ] Load STL file
- [ ] Make sorting more stable by using keys when no-order.
- [ ] Shaders need to be able to draw whenever in rendering process. E.g. an outline shader needs to draw at end. Make sure this is possible.
- [ ] Add click detection. Insert a SceneItem which internally generates a clickable RenderItem. Triggers callback, with mouse coordinates, and maybe 3D coordinate of intersection with clicked RenderItem.
- [ ] Debug with keys. Improve keys. Make the key passing on compilation automatic? Keys may not be needed for sorting given its with a DAG, so they become purely for debugging, and therefore completely optional?
- [ ] Add convenience parameters to SceneItem (SRT, debug info)
- [ ] For each RenderItem render function, make it save and restore canvas state. (think things like clipRect).
- [ ] Check cube face orientation generation with debug labels.
- [ ] Fix camera fov (should it be fixed?)
- [ ] Support canvas.saveLayer in shaders
- [ ] Support custom tri normals?
    - Only useful for lighting
- [ ] View frustum culling.
- [ ] Function to load in mesh files and automatically group them together into convex hulls for more efficient rendering. Should also auto-split intersecting tris.
- [ ] Live split tris which intersect.
- [ ] Split functionality into libraries
    - Sorting as graph library
    - Rendering
        - Camera & projection
        - SceneItems
        - ProcessItems
        - RenderItems
    - Flutter specific (e.g. APIs over Canvas and Color; CustomPaint(er);)
- [ ] Re-introduce Scene class to store items?
- [ ] Shadows ?!??!?!?
- [ ] Combine multiple tri-drawings into a single .drawVertices for performance? Use SortResult.None to help know which you can combine
- [ ] drender, use circle to draw spheres, but consider its size properly based on tangent to camera line
- [ ] dan engine / render, look into using lower level Flutter APIs for better performance.
- [ ] flutter canvas supports perspective. Use this for texturing.
    - Matrix4.identity()..setEntry(3, 2, 0.001)..rotateX(-0.2);

TODO: IMPORTANT

TODO: EXTRA MODULES

TODO: POLISH

DONE
- [x] Add basic keys for debugging
- [x] Reduce false order dependency. Require slight overlap with epsilon value with tri intersect plane check.
- [x] Fix topological sort by starting with no-parent nodes.
- [x] Add co-planar check to parallel tris, and return no-order.
- [x] Fix null error when tris cross camera plane
- [x] Fix camera rotation
