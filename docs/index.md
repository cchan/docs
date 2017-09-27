# Team Waterloop

Canada's Hyperloop, designed and built at the University of Waterloo.
This is the documentation hub for all components of our pod.

This site is not intended for sharing outside of the team.

## Adding documentation

The first time, you need to clone the entire repository:

- `git clone https://github.com/teamwaterloop/docs`
- `cd docs`

Any time after that, you just need to pull the changes from GitHub written by other team members.

- `git pull`

To edit:

- Edit the relevant files in the `docs` folder. Files are written in 
    [Markdown](http://commonmark.org/help/), with a couple of 
    [extensions](http://www.mkdocs.org/user-guide/writing-your-docs/#markdown-extensions).

- Modify the navigation bar in `mkdocs.yml` as necessary.

- `git commit -m "<a brief descriptive message about what you added>"`

- `git push` (you may need to enter a username and password)

After pushing, the updated documentation will be compiled and deployed to 
[docs.teamwaterloop.ca](https://docs.teamwaterloop.ca) within a couple of minutes.

## Building locally

To build locally, you need to first install Python, then do the following:

- `pip install mkdocs mkdocs-cinder`

- `mkdocs build`

- `cd site`

- If Python 3: `python -m http.server 4000`, if Python 2: `python -m SimpleHTTPServer 4000`

- And then navigate to `localhost:4000` to see your work!
