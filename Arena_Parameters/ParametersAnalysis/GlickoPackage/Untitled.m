x=[1 2 3]
y=[2 4 6;6 7 8;9 2 7];
figure 
ax=axes;
ax.LineStyleOrder={'-','--o',':s'};
ax.NextPlot='add';
plot(x,y)