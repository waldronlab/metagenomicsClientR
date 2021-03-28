## -----------------------------------------------------------------------------
library(dplyr)
library(metagenomicsClientR)

## -----------------------------------------------------------------------------
basePath = 'https://cmgd-telemetry-whnnxetv4q-uc.a.run.app'
client = ApiClient$new(basePath = basePath)
api = DefaultApi$new(apiClient = client)

## -----------------------------------------------------------------------------
api

## -----------------------------------------------------------------------------

api$GetSamplesMetadataSamplesGet()

api$GetUuidFromStringMetadataUuidGet(string = "Asnicar_2021")

api$SamplesForStudyMetadataStudiesUuidSamplesGet(uuid = "b3416924-2c11-519b-95ba-42d388114c5f")





## -----------------------------------------------------------------------------
qres = api$ListFileEventsFilesChangesGet()
qres

## -----------------------------------------------------------------------------
hit_list = qres$toJSON()$hits
df = bind_rows(hit_list)

## -----------------------------------------------------------------------------
glimpse(df)

## -----------------------------------------------------------------------------
class(qres)

## -----------------------------------------------------------------------------
class(qres$hits[[1]])

## -----------------------------------------------------------------------------
StorageEventReturn

## -----------------------------------------------------------------------------
StorageEventCollection

