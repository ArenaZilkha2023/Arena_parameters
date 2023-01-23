function [OptimalCluster,DBvalues,Cdominant,Csubmisse,DB]=ClusterPCAClustering(score,ExpRank)

S=[score(:,1),score(:,2)];
%This function cluster and define the dB criteria
eva = evalclusters(S,'kmeans','DaviesBouldin','KList',[1:5]); %look for 5 clusters-we choose kmeans as the clustering method 

OptimalCluster=eva. OptimalK;
DBvalues=eva.CriterionValues;
%% Evaluate manually the cluster DB
%Cluster only the dominant
Sd=[score(ExpRank==1,1),score(ExpRank==1,2)];
[idx,Cdominant]=kmeans(Sd,1); %for centroid calculation of the dominant


%Cluster fodr everybody except dominant
Ss=[score(ExpRank~=1,1),score(ExpRank~=1,2)];
[idx,Csubmisse]=kmeans(Ss,1); %for centroid calculation of the dominant

%calculate average distance between the centroid and points in every cluste
ddom=mean(((Sd(:,1)-Cdominant(1)).^2+(Sd(:,2)-Cdominant(2)).^2).^0.5);
dsub=mean(((Ss(:,1)-Csubmisse(1)).^2+(Ss(:,2)-Csubmisse(2)).^2).^0.5);

%calculate distance between centroids

ddomsub=((Csubmisse(1)-Cdominant(1))^2+(Csubmisse(2)-Cdominant(2))^2)^0.5;
%Use matlab definition for DB
DB=((ddom+dsub)/(ddomsub))^2;
end