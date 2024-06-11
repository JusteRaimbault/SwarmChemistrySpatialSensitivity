
setwd(paste0(Sys.getenv('CS_HOME'),'/SimulationModels/Models/SwarmChemistrySpatialSensitivity'))

library(dplyr,warn.conflicts = F)
library(readr)
library(GGally)

source(paste0(Sys.getenv('CS_HOME'),'/Organisation/Models/Utils/R/plots.R'))

resprefix = '20240416_115624_PSE'

res <- read_csv(file=paste0('openmole/pse/',resprefix,'/population1000.csv'),col_names = T)
names(res)[4] = "Generator"

resdir = paste0('results/',resprefix,'/');dir.create(resdir,recursive = T)

ggsave(
  plot=ggpairs(data=res,columns = c("c1avg","c1std","c2avg","c2std", "c3avg", "c3std"),
               aes(colour=Generator,alpha=0.4)
  )+stdtheme,
  filename =paste0(resdir,"pse-scatterplot_colorGenerator.png"),width=30,height=30,units='cm')


# counts and hypervolumes

table(res$Generator)

# hypervolumes
indics = c("c1avg","c1std","c2avg","c2std", "c3avg", "c3std")
d = as.matrix(res[,indics])
for(j in 1:ncol(d)){d[,j] = (d[,j] - mean(d[,j]))/sd(d[,j])}

library(hypervolume)
totalVolume = hypervolume(d,method='box')@Volume
for(gen in unique(res$Generator)){
  show(gen)
  show(hypervolume(d[res$Generator==gen,],method='box')$Volume/totalVolume)
}


# linear model for each output
for(output in c("c1avg","c1std","c2avg","c2std", "c3avg", "c3std")){
  show(summary(lm(formula=paste0(output, "~Generator"), data=res)))
}




