# Updating master branch
* Update `NEWS.md` with the date of your change and the summary of changes that
  are going into this
* Update `README.md` with the new version, `x.y`, `x+1` if breaking, `y+1` if
  not
* Update `docs/schema/concrete_info.js` with new version number from above
* Regenerate docs
  * To do this, you need `python3`, then run:
    * `pip install -r requirements.txt` (if needed)
    * `cd docs`
    * `sh regenerate_docs.sh $(which thrift)` (or pass in another
      thrift executable)
