Example of simple workspace creation and combine commands

```
cd 2016-prefit
```

To make the workspace:
```
python make_cards.py
./make_workspace.sh
```

Creates a workspace with 2 POI: rggF and rVBF in output/testmodel_2016/model_combined.root

2D plots of the QCD MC pass/fail transfer factor are automatically saved to plots.
To draw plots of this fit in each pT / mjj bin, do 
```
root -l draw_PFratio_QCDMC.C
```

Try running combine methods (make sure to always use option -t -1 to avoid unblinding).
For debugging, it can be useful to add --verbose 9 to some of these combine commands.

Expected ggF and VBF significance:
```
./exp_significance.sh
```

Fitted msd distribution in each pT / mjj bin:
```
./exp_shapes.sh
root -l draw_datafit.C
```
This can be slow.

One dimensional likelihood distributions:
```
./exp_mu.sh rggF
./exp_mu.sh rVBF
root -l draw_likelihood.C
```
NB: no stat only likelihood is calculated here since the model so far does not include systematics

Two dimensional likelihood contours:
```
./exp_contour.sh 0.68
./exp_contour.sh 0.95
root -l draw_contour.C
```

1D and 2D likelihood can also be slow to run. Reduce $npoints to make it run quicker, but you will not get as smooth a curve.
