function result=AddRank(x,rawRanking,numRank)

result=numRank(find(strcmp(strrep(x,'''',''),strrep(rawRanking(:,1),'''',''))==1),1);

end

