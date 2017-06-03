# Webscale Bounding Box

After downloading images with `fetch-flickr`, use this tool to quickly annotate bounding
boxes in found images.

Why yet another tool? Tool like sloth or labelme offer more functionality in terms of labeling,
but their general-purpose-ness makes them also very time-inefficient (do you really expect
me to wait 5s for a save file dialogue after each and every image?). This tool can't do as much,
but it can do it fast.

## Usage / Features

With the `LeftArrow` and `RightArrow`, you can switch between images in the selected folder.
Press `N` to define that there is no bounding box (the desired object isn't found). Else, use
the mouse to define the two points of the bounding box.

After each interaction, the result is stored and the program proceeds to the next image.

With a bit of training, you can reach a rate of 30 images per minute 🚀.

## Installation

1. Install node.js
2. Clone repository
3. Run `npm install` in cloned repository
4. Run `npm run buildClient` to build the files for the client-side part of the application

## Startup

Run `npm run startServer` to start the server. You can now go to `http://localhost:3000`.
Three example images are already loaded (with annotated labels). Either replace the images in the folder
or tell the server with `--imagePath <dir>` where to look.
