rm(list=ls())
library(tidyverse)
library(tree)

set.seed(10)

records <- read_csv2("verlaufe-sozialhilfe-ruckerstattungen-stadt-stgallen.csv")
features <- read_csv2("eigenschaften-sozialhilfeempfaenger-stadt-st-gallen.csv")

records.in = subset(records, is.na(records$`Dossier bis`))
records.out = subset(records, !is.element(records$ID, records.in$ID))

# features contain all id in records, and more
# features <- subset(features, is.element(features$id, records.out$ID))
features <- subset(features, !is.element(features$id, records.in$ID))

features <- as.data.frame(unclass(features),stringsAsFactors=TRUE)
summary(features)

split = sample.split(features$Produkt.letzte.Dossierversion, SplitRatio = 0.7)
train = subset(features, split == TRUE)
test = subset(features, split == FALSE)



tree.model = tree(Produkt.letzte.Dossierversion ~ Dossier.Art + Personenhaushalt..Unterstützungseinheit. + Personenkategorie + Zivilstand + Nationalität.Kategorien + in.CH.seit.Geb. + Alterskategorien + Erwerbssituation + Beschäftigungsgrad + Grund.Teilzeit + höchste.abgeschlossene.Ausbildung,
            data = train, na.action = na.pass)

plot(tree.model)
text(tree.model, pretty = 0)
tree.pred.class=predict(tree.model, test, type="class")
tree.pred.prob=predict(tree.model, test, type="vector")
print(table(tree.pred.class, test$Produkt.letzte.Dossierversion))
hist(tree.pred.prob[,2])




output <- data.frame(test, tree.pred.prob[,2])
output <- rename(output, prob.low.willingness = tree.pred.prob...2.)
write.csv(output,"output.csv", row.names = FALSE)
