
setwd(paste0(Sys.getenv('CS_HOME'),'/SimulationModels/Models/SwarmChemistrySpatialSensitivity'))

library(dplyr,warn.conflicts = F)
library(readr)
library(GGally)

source(paste0(Sys.getenv('CS_HOME'),'/Organisation/Models/Utils/R/plots.R'))

#resprefix = '20240416_115624_PSE' # 494 individuals at generation 1000
resprefix = '20240612_204324_PSE' # 714 at generation 1900, 758 at 2100

# read old pse format
#res <- read_csv(file=paste0('openmole/pse/',resprefix,'/population1000.csv'),col_names = T)
# new format exported from omr
res <- read_csv(file=paste0('openmole/pse/',resprefix,'.csv'),col_names = T)

names(res)[4] = "Generator"

resdir = paste0('results/',resprefix,'/');dir.create(resdir,recursive = T)

ggsave(
  plot=ggpairs(data=res,columns = c("c1avg","c1std","c2avg","c2std", "c3avg", "c3std"),
               aes(colour=Generator,alpha=0.4),
               # proper column labels: https://github.com/ggobi/ggally/issues/207
               columnLabels = c("bar(c[1])","sigma~(c[1])","bar(c[2])",'sigma~(c[2])', 'bar(c[3])', 'sigma~(c[3])'), labeller = label_parsed
  )+scale_x_continuous(breaks = scales::pretty_breaks(n = 3))+
    scale_y_continuous(breaks = scales::pretty_breaks(n = 3))+
    theme(strip.text = element_text(size=18)),#+stdtheme,
  filename =paste0(resdir,"pse-scatterplot_colorGenerator.png"),width=25,height=25,units='cm', dpi = 72)


# MANOVA to test for statistical differences between generators
manova(data=res[,c("Generator","c1avg","c1std","c2avg","c2std", "c3avg", "c3std")],
               formula = cbind(c1avg,c1std,c2avg,c2std, c3avg, c3std)~Generator)

gens=unique(res$Generator)
for(indic in c("c1avg","c1std","c2avg","c2std", "c3avg", "c3std")){
  for(i in 1:(length(gens)-1)){
    for(j in (i+1):length(gens)){
      generator1 = gens[i]; generator2 = gens[j]
      #test = t.test(jitter(unlist(res[res$Generator==generator1,indic]),factor=0.01),jitter(unlist(res[res$Generator==generator2,indic]), factor=0.01))
      test = t.test(unlist(res[res$Generator==generator1,indic]),unlist(res[res$Generator==generator2,indic]))
      
      if(test$p.value<=0.1){
      show(paste0(indic," : ",generator1," - ",generator2," : pval = ",test$p.value))
      }
    }
  }
}

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




