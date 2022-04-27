# TrackTool

Goal: A piece of software that provides a suite of tools to denote walls of a building, track layouts, and vehicle motion for simple attractions in a 2D space

Functional Modes:
 - Facility Editor
   - An interface that allows for the definition of buildings (a collection of walls, either enclosed or open)
   - Simple, click to add point UI
   - Treat each structure as a collection of line segments
   - Might as well allow for bezier curves, whatever
 - Track Editor
   - Define track segments as bezier curves, straight lines, whatever
   - Can be a loop, or, single segment
   - Allow for joining of track segments at junctions
   - Similar interface as the facility editor, just with a different purpose / context
 - Motion Editor
   - Keyframe / animation editor - define position at point, system interpolates between that
   - Goals: Animation curves
   - Generalize animation stuff so we can implement multiple axes, but as of yet, initial goal is yaw / velocity.
 - Export
   - Render ride footage to video, either locked on camera, locked on facility, or other stuff

UI requirements for facility:
 - Canvas
 - Tool Bar (add point, delete point, adjust point (curve), delete structure)
 - Object / settings panel? Unknown
 - Minimap?
