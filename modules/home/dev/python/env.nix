{ pkgs }:
pkgs.python3.withPackages (
  ps: with ps; [
    pynvim
    cairosvg
    pnglatex
    matplotlib
    seaborn
    scikit-learn
    sqlalchemy
    plotly
    pyperclip
    ipython
    ipykernel
    jupytext
    numpy
    pandas
    pandas-stubs
    scipy
    jupyter-cache
  ]
)
