



  # analysis of "ecosystem indicators"

  # -----------------------------
  # ordination
  if (!exists("year.assessment")) {
    year.assessment=lubridate::year(Sys.Date())
    year.assessment=lubridate::year(Sys.Date()) -1
  }
  p = bio.snowcrab::snowcrab_parameters( yrs=1999:year.assessment )

  # setwd( project.datadirectory("aegis") )

  # not all are fully refreshed automatically .. they are just place holders for now

      groundfish = aegis_ts_db( db="groundfish.timeseries.redo" )
      snowcrab = aegis_ts_db( db="snowcrab.timeseries.redo")
      climate = aegis_ts_db (db="climate.redo" )
      shrimp = aegis_ts_db( db="shrimp.timeseries.redo")

      sar = aegis_ts_db( db="species.area.redo" )
      nss = aegis_ts_db( db="sizespectrum.redo" )
      metab = aegis_ts_db( db="metabolism.redo" )
      sc = aegis_ts_db( db="species.composition.redo" )

      economics = aegis_ts_db( db="economic.data.redo" )

      # hand constructed and updated .. TODO :: find solutions!
      #plankton = aegis_ts_db( db="plankton.timeseries.redo" )
      human = aegis_ts_db( db="demographics.redo" )


      #seals = aegis_ts_db( db="seal.timeseries.redo" )
      landedvalue = aegis_ts_db( db="landedvalue.annual.redo", ref.year=2008 )
      landings = aegis_ts_db( db="landings.annual.redo" )





# require( xlsReadWrite )
# data = read.xls( "mydata.xls", sheet="Sheet1" )
#
# for ( y in
# http://www.gov.ns.ca/finance/communitycounts/export.asp?bExcel=1&page=table_d17&dgroup=&dgroup1=&dgroup2=&dgroup3=&dgroup4=&yearid=2011&gnum=pro9012&gname=Nova%20Scotia&range=
#
# require( XLConnect )
# fn = "~/Downloads/estimates.xls"
# wb <- loadWorkbook( fn)
# data <- readWorksheet(wb)




  indic = aegis_ts_db( db="aegis.all.glue" )  # glue all time-series together
  # indic = aegis_ts_db( db="aegis.all" ) # load the glued version


 # indic$data$Nwells.drilled = cumsum.jae(indic$data$Nwells.drilled)
 # indic$data$seismic.2D = cumsum.jae(indic$data$seismic.2D)
 # indic$data$seismic.3D = cumsum.jae(indic$data$seismic.3D)


  t0 = 1960
  t1 = 2015

  # ordination of selected key factors
  indic = aegis_ts_db( db="aegis.all" )

  d = aegis.subset ( indic, type="keyfactors" )
#  save( d, file="/home/adam/tmp/ordin.rdata", compress=TRUE )

  Y = pca.analyse.data(d, t0, t1, fname=file.path(project.datadirectory("aegis"), "keyfactors" ) )


  sub = indic$data[, c("T_bottom_misaine", "SST_halifax", "ice_coverage.km.2", "Gulf.Stream.front.Ref.62lon", "T_sable_annual", "snowcrab.bottom.habitat.area", "snowcrab.kriged.R0.mass", "snowcrab.fishery.landings", "snowcrab.fishery.cpue", "groundfish.stratified.mean.temp" )]

  write.table(sub, file=file.path( project.datadirectory( "bio.snowcrab"), "research", "environ.management", "data.csv"), sep=";")


inn = names (indic$data)
for (i in .keyfactors) {
  if ( i %in% inn ) next()
  print (i)
}


  ## smaller subsets


  # human
  .human = c(indic$landings.totals.NS, indic$landedvalue.totals.NS, indic$human )
  .human = setdiff( .human, "No.Fish.processors" ) # this has no data yet
  Y = pca.analyse.data( indic$data, .human, t0, t1, fname=file.path(project.datadirectory("aegis"), "human") )

  # fishery landings
  .fishery = c(indic$landings.NS, indic$landings.totals.NS )
  Y = pca.analyse.data( indic$data, .fishery, t0, t1, fname=file.path(project.datadirectory("aegis"), "fishery" ))

  # fishery landed value
  .fishery.value = c(indic$landedvalue.NS, indic$landedvalue.totals.NS )
  Y = pca.analyse.data( indic$data, .fishery.value, t0, t1, fname=file.path(project.datadirectory("aegis"), "landedvalue" ))

  # fishery -- overall
  .fishery = c(indic$landedvalue.NS, indic$landedvalue.totals.NS, indic$landings.NS, indic$landings.totals.NS )
  Y = pca.analyse.data( indic$data, .fishery, t0=1970, t1, fname=file.path(project.datadirectory("aegis"), "fishery.overall" ))

  # snowcrab
  .snowcrab = c(indic$snowcrab, "groundfish.stratified.mean.totwgt.snowcrab", "groundfish.stratified.mean.totno.snowcrab" )
  Y = pca.analyse.data(indic$data, .snowcrab, t0, t1, fname=file.path(project.datadirectory("aegis"), "snowcrab" ))

  # climate
  .climate = c( indic$climate )
  Y = pca.analyse.data(indic$data, .climate, t0, t1, fname=file.path(project.datadirectory("aegis"), "climate" ))

  # ecosystem
  .ecosystem = c( indic$ecosystem )
  Y = pca.analyse.data(indic$data, .ecosystem, t0, t1, fname=file.path(project.datadirectory("aegis"), "ecosystem" ))








## ---------------
##  Todo : bayesian PCA

require(bmvm)
loadfunctions("bmvm")  ## mostly complete


 ...  incomplete

  # figures and tables related to fishery indices

  if (!exists("year.assessment")) year.assessment=lubridate::year(Sys.Date())

  p = bio.snowcrab::snowcrab_parameters( yrs=1999:year.assessment )

  set = snowcrab.db("set.with.cat")
  allvars = c(
      "totno.all", "totno.male", "totno.male.com", "totno.male.ncom", "totmass.male.imm", "totmass.male.mat",
      "totmass.all", "totmass.male", "totmass.male.com", "totmass.male.ncom", "totno.male.imm", "totno.male.mat",

      "totno.male.soft", "totno.male.hard",
      "totmass.male.soft", "totmass.male.hard",

      "totno.female.soft", "totno.female.hard",
      "totmass.female.soft", "totmass.female.hard",

      "R0.no", "R1.no", "R2.no", "R3.no", "R4.no", "R5p.no", "dwarf.no",
      "R0.mass", "R1.mass", "R2.mass", "R3.mass", "R4.mass", "R5p.mass", "dwarf.mass",

      "totmass.female", "totmass.female.mat", "totmass.female.imm",
      "totmass.female.berried", "totmass.female.primiparous", "totmass.female.multiparous",

      "totno.female", "totno.female.mat", "totno.female.imm",
      "totno.female.berried", "totno.female.primiparous", "totno.female.multiparous",

      "totmass.male.com.CC1to2", "totmass.male.com.CC3to4", "totmass.male.com.CC5",
      "totno.male.com.CC1to2", "totno.male.com.CC3to4", "totno.male.com.CC5",

      "cw.fem.mat.mean", "cw.fem.imm.mean",
      "cw.male.mat.mean", "cw.male.imm.mean",

      "cw.mean", "cw.comm.mean", "cw.notcomm.mean",

      "sexratio.imm", "sexratio.mat", "sexratio.all",

      "z", "t",

      "uniqueid"
    )

    x = set[, allvars]
    for (v in allvars)  x[,v] = recode.variable(x[,v], v)$x  # normalise the data where required

    rownames(x) = x$uniqueid
    x$uniqueid = NULL
    p = pca.modified(x)



# ----


project.library( "aegis", "stmv", "aegis")

setwd( project.datadirectory("aegis", "data") )

# not all are fully refreshed automatically .. they are just place holders for now
groundfish = aegis_ts_db( db="groundfish.timeseries.redo" )
snowcrab = aegis_ts_db( db="snowcrab.timeseries.redo")
climate = aegis_ts_db (db="climate.redo" )
shrimp = aegis_ts_db( db="shrimp.timeseries.redo")

sar = aegis_ts_db( db="species.area.redo" )
nss = aegis_ts_db( db="sizespectrum.redo" )
metab = aegis_ts_db( db="metabolism.redo" )
sc = aegis_ts_db( db="species.composition.redo" )

economics = aegis_ts_db( db="economic.data.redo" )

# hand constructed and updated .. TODO :: find solutions!
#plankton = aegis_ts_db( db="plankton.timeseries.redo" )
human = aegis_ts_db( db="demographics.redo" )
#climate = aegis_ts_db (db="climate.redo" )

#seals = aegis_ts_db( db="seal.timeseries.redo" )
landedvalue = aegis_ts_db( db="landedvalue.annual", ref.year=2008 )
landings = aegis_ts_db( db="landings.annual" )

# refresh the survey data
# DEMOGRAPHICS goto:: http://www.gov.ns.ca/finance/communitycounts/dataview.asp?gnum=pro9012&gnum2=pro9012&chartid=&whichacct=&year2=&mapid=&ptype=&gtype=&yearid=2006&acctype=0&gname=&dcol=&group=&group1=&group2=&group3=&gview=3&table=table_d17&glevel=pro


# require( xlsReadWrite )
# data = read.xls( "mydata.xls", sheet="Sheet1" )
#
# for ( y in
# http://www.gov.ns.ca/finance/communitycounts/export.asp?bExcel=1&page=table_d17&dgroup=&dgroup1=&dgroup2=&dgroup3=&dgroup4=&yearid=2011&gnum=pro9012&gname=Nova%20Scotia&range=
#
# require( XLConnect )
# fn = "~/Downloads/estimates.xls"
# wb <- loadWorkbook( fn)
# data <- readWorksheet(wb)


indic = aegis_ts_db( db="aegis.all.glue" )  # glue all time-series together
# indic = aegis_ts_db( db="aegis.all" ) # load the glued version

# indic$data$Nwells.drilled = cumsum.jae(indic$data$Nwells.drilled)
# indic$data$seismic.2D = cumsum.jae(indic$data$seismic.2D)
# indic$data$seismic.3D = cumsum.jae(indic$data$seismic.3D)

t0 = 1960
t1 = 2015

# ordination of selected key factors
indic = aegis_ts_db( db="aegis.all" )

#   d = subset( indic, type="keyfactors" )
#   save( d, file="/home/adam/tmp/ordin.rdata", compress=TRUE )

Y = pca.analyse.data(indic, t0, t1, fname=file.path(project.datadirectory("aegis"), "keyfactors" ) )


sub = indic$data[, c("T_bottom_misaine", "SST_halifax", "ice_coverage.km.2", "Gulf.Stream.front.Ref.62lon", "T_sable_annual", "snowcrab.bottom.habitat.area", "snowcrab.kriged.R0.mass", "snowcrab.fishery.landings", "snowcrab.fishery.cpue", "groundfish.stratified.mean.temp" )]

write.table(sub, file=file.path( project.datadirectory( "bio.snowcrab"), "research", "environ.management", "data.csv"), sep=";")


inn = names (indic$data)
for (i in .keyfactors) {
  if ( i %in% inn ) next()
  print (i)
}


## smaller subsets
# human
.human = c(indic$landings.totals.NS, indic$landedvalue.totals.NS, indic$human )
.human = setdiff( .human, "No.Fish.processors" ) # this has no data yet
Y = pca.analyse.data( indic$data, .human, t0, t1, fname=file.path(project.datadirectory("aegis"), "human") )

# fishery landings
.fishery = c(indic$landings.NS, indic$landings.totals.NS )
Y = pca.analyse.data( indic$data, .fishery, t0, t1, fname=file.path(project.datadirectory("aegis"), "fishery" ))

# fishery landed value
.fishery.value = c(indic$landedvalue.NS, indic$landedvalue.totals.NS )
Y = pca.analyse.data( indic$data, .fishery.value, t0, t1, fname=file.path(project.datadirectory("aegis"), "landedvalue" ))

# fishery -- overall
.fishery = c(indic$landedvalue.NS, indic$landedvalue.totals.NS, indic$landings.NS, indic$landings.totals.NS )
Y = pca.analyse.data( indic$data, .fishery, t0=1970, t1, fname=file.path(project.datadirectory("aegis"), "fishery.overall" ))

# snowcrab
.snowcrab = c(indic$snowcrab, "groundfish.stratified.mean.totwgt.snowcrab", "groundfish.stratified.mean.totno.snowcrab" )
Y = pca.analyse.data(indic$data, .snowcrab, t0, t1, fname=file.path(project.datadirectory("aegis"), "snowcrab" ))

# climate
.climate = c( indic$climate )
Y = pca.analyse.data(indic$data, .climate, t0, t1, fname=file.path(project.datadirectory("aegis"), "climate" ))

# ecosystem
.ecosystem = c( indic$ecosystem )
Y = pca.analyse.data(indic$data, .ecosystem, t0, t1, fname=file.path(project.datadirectory("aegis"), "ecosystem" ))
