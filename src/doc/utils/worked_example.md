# A worked example

## Prerequisites

In the [`examples/density_count_model`](https://github.com/wwaites/saved_fisdat/tree/main/examples/density_count_model) directory, there is a pre-prepared manifest file which uses three cage data totals files, and an example time-series of densities.

## Preparing the initial manifest file with `fisdat`

Before specifying any job, we need to generate an initial manifest file which we can fill out. This will add the three cage data files as tables, and will also add boilerplate for an example, ignored job.

There are four target data files which we are going to add:

  1. The time series of densities. The schema file (`density.yaml`) is very simple.
  2. Cage data for cage #8, autumn 2011, deployed 26/10 - 01/11. The schema file is identical to the sentinel cages data example.
  3. Cage data for cage #9, autumn 2011, deployed 26/10 - 01/11. Same schema file.
  4. Cage data for cage #10, autumn 2011, deployed 26/10 - 01/11. Same schema file.
  
  
The target file to work on is going to be called `test_manifest.yaml`.

Let's start by adding the density time series to our new manifest file:

	fisdat density.yaml density.csv test_manifest.yaml
	
We should see something not unlike the following:

	This is fisdat version 0.7, commit a70efdba00aaff8dce42f0a698b8f1af572a5b3f
    Wrote to test_manifest.yaml:
    ------------------------------------------
    | data URI    | data schema  | data hash |
    ------------------------------------------
    | density.csv | density.yaml | 1974c2dbe |
    ------------------------------------------
	
Now, let's add one of the cage data files:

	fisdat sentinel_cages_sampling.yaml deployment_2011-10-26_2011-11-01_cage_8.csv test_manifest.yaml

We should now see something as follows:

	Wrote to test_manifest.yaml:
    ------------------------------------------------------------------------------------------
    | data URI                                    | data schema                  | data hash |
    ------------------------------------------------------------------------------------------
    | density.csv                                 | density.yaml                 | 1974c2dbe |
    | deployment_2011-10-26_2011-11-01_cage_8.csv | sentinel_cages_sampling.yaml | 0b93c10c8 |
    ------------------------------------------------------------------------------------------
	
Now, add the other two cage data files to the file. Output should be very similar to the above.

	fisdat sentinel_cages_sampling.yaml deployment_2011-10-26_2011-11-01_cage_9.csv test_manifest.yaml
	fisdat sentinel_cages_sampling.yaml deployment_2011-10-26_2011-11-01_cage_10.csv test_manifest.yaml
	
## Editing the initial manifest file

### Titles and descriptions
We should now have a usable manifest file describing the structure of the data package to upload. Let's have a look at it.

```yaml
atomic_name: RootManifest

tables:

- atomic_name: density
  resource_path: density.csv
  resource_hash: 1974c2dbefaeaaa425a789142e405f7b8074bb96348b24003fe36bf4098e6b58e2227680bcf72634c4553b214f33acb4
  schema_path_yaml: density.yaml
  
- atomic_name: deployment_2011-10-26_2011-11-01_cage_8
  resource_path: deployment_2011-10-26_2011-11-01_cage_8.csv  
  resource_hash: 0b93c10c8de980fe7213040096dcabb4f7c66efe03ea1f479007da6ea2800b0b2e226b854c6f1a0b22c742a9cae0ec99
  schema_path_yaml: sentinel_cages_sampling.yaml

- atomic_name: deployment_2011-10-26_2011-11-01_cage_9
  resource_path: deployment_2011-10-26_2011-11-01_cage_9.csv
  resource_hash: 89361535458427edda4c59e609553a897b3f1110f1c6d97c9bb43196715c3c48f8d0da1536429eb2b21a0d4f6bbd9f1e
  schema_path_yaml: sentinel_cages_sampling.yaml
  
- atomic_name: deployment_2011-10-26_2011-11-01_cage_10
  resource_path: deployment_2011-10-26_2011-11-01_cage_10.csv
  resource_hash: 5b75481628cfaf3206721491c906a95348f7abd32a9c70a82f57821add8169fb7abd174314a669bed9612183345a295f
  schema_path_yaml: sentinel_cages_sampling.yaml
  
jobs:

- atomic_name: job_example_density
  job_type: ignore
  title: Empty job template for density
  
local_version: 0.7+4.ga70efdb.dirty
```

While this would be sufficient for uploading (indeed, the job is just ignored), there are a couple of things to note.

First, the `fisdat` program knows nothing about the title of data proper (this is distinct from the title of the schema). We might add a title for a given table (although this is not required), something like the following:

```yaml
- atomic_name: deployment_2011-10-26_2011-11-01_cage_8
  title: Cage 8, season A11, deployment 1 (2011-10-26 - 2011-11-01)
  description: Derived from the sentinel cages example
  resource_path: deployment_2011-10-26_2011-11-01_cage_8.csv
  resource_hash: 0b93c10c8de980fe7213040096dcabb4f7c66efe03ea1f479007da6ea2800b0b2e226b854c6f1a0b22c742a9cae0ec99
  schema_path_yaml: sentinel_cages_sampling.yaml
```

After adding this, check that upload using this file would be possible, using the `--dry-run` option of `fisup`. This is useful since it won't make any conversions of schema/manifest to different formats (but will load the file).

	fisup --dry-run test_manifest.yaml
	
We should see something not unlike the following: 

```
This is fisup version 0.7, commit a70efdba00aaff8dce42f0a698b8f1af572a5b3f
Target file test_manifest.converted.ttl doesn't exist, so overwrite
Target file density.converted.ttl exists, and force-overwrite (`--force' option) is set, so overwrite
Would have converted schema from YAML density.yaml to TTL density.converted.ttl
Would have converted schema from YAML sentinel_cages_sampling.yaml to TTL sentinel_cages_sampling.converted.ttl
Would have converted schema from YAML sentinel_cages_sampling.yaml to TTL sentinel_cages_sampling.converted.ttl
Would have converted schema from YAML sentinel_cages_sampling.yaml to TTL sentinel_cages_sampling.converted.ttl
Successfully converted all schemata from YAML to TTL
Would have converted manifest from YAML test_manifest.yaml to TTL test_manifest.converted.ttl
Would have written the following to index file .index:
-----------------------------------------------------------
| test_manifest.yaml                                      |
| test_manifest.converted.ttl                             |
| https://marine.gov.scot/metadata/saved/rap/             |
| https://marine.gov.scot/metadata/saved/rap/RootManifest |
-----------------------------------------------------------
Would upload to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1/test_manifest.yaml ...
Would upload to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1/test_manifest.converted.ttl ...
Would upload to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1/.index ...
Would upload to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1/density.csv ...
Would upload to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1/deployment_2011-10-26_2011-11-01_cage_8.csv ...
Would upload to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1/deployment_2011-10-26_2011-11-01_cage_9.csv ...
Would upload to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1/deployment_2011-10-26_2011-11-01_cage_10.csv ...
Would upload to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1/density.yaml ...
Would upload to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1/sentinel_cages_sampling.yaml ...
Would upload to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1/sentinel_cages_sampling.yaml ...
Would upload to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1/sentinel_cages_sampling.yaml ...
Would upload to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1/density.converted.ttl ...
Would upload to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1/sentinel_cages_sampling.converted.ttl ...
Would upload to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1/sentinel_cages_sampling.converted.ttl ...
Would upload to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1/sentinel_cages_sampling.converted.ttl ...
Would have uploaded your data/job set/bundle to gs://saved-fisdat/strathclyde/20240730/22464600-4e62-11ef-ad7c-f218987e77f1

```

## Specifying a job

The key thing which we're able to do is specify a job. Currently, we have implemented a job which runs an ODE model for sea lice count accumulation. This expects the following data input:

  1. A time series of modelled lice densities
  2. A count of totals found on individual fish, after sampling a cage 
  
When specifying the job, the names of columns are linked together with three pieces of information:

  1. The name of a table appended to the manifest file
  2. The name of the column of interest in that table
  3. The underlying variable in the data model. This is particularly important as it is used when running the job to identify the column in question.
  
The job descriptions are structured with a very short name/identifier (the `atomic_name` attribute), job type (currently only "density" and "ignore" are valid), a list of columns which are based on observed/collected data, and a list of columns which are based on modelled/simulated data. There is an optional title/description field as before.

For the density job, specifically, we expect the following information:

  1. Job type as `density`.
  1. Under the list of *collected* columns/variables/tables to bring into scope, a specification for observed count of lice totals. The underlying variable against which the pipeline pattern-matches is `saved:lice_af_total`.
  2. Under the list of *modelled* columns/variables/tables to bring into scope, a specification of a column for a time series and a specification of a column for associated modelled density in that time series. The underlying variables against which the pipeline pattern-matches are `saved:time` and `saved:density` respectively.
  
Let's try adding this to the manifest file:

```yaml
- atomic_name: job_dens_cage8_a11_dep1
  job_type: density
  title: Density job for cage 8, season A11, deployment 1
  job_scope_collected:
  - column: TOTAL
    variable: saved:lice_af_total
    table: deployment_2011-10-26_2011-11-01_cage_8
  job_scope_modelled:
  - column: time
    variable: saved:time
    table: density
  - column: density
    variable: saved:density
    table: density
```

Now, let's see if it's at least valid YAML (notwithstanding actually running the job, which is after we upload): 

	fisup --dry-run test_manifest.yaml
	
We should see identical results to the last time we ran that command.

Recall that we also added two other data files to the manifest file. These all have the same column naming, since they are derived from the same source file (narrowed down to specific cages/deployments), and are named near-identically, so try adding the above job description, just replacing `cage_8` with `cage_9` and `cage_10` respectively.

## Uploading the data package with `fisup`

Now that we've specified a (hopefully) valid set of jobs, we can upload for real. The `fisup` program does a couple of things to prepare for uploading:

  1. The YAML schema files are converted to RDF/TTL
  2. The manifest file is converted to RDF/TTL (or, if in RDF/TTL format, to YAML)
  3. An 'index' file is created which describes the base prefix/target object when loading
  
Target files which are converted have '.converted' prepended to the file extension, so they won't overwrite current work. Further note that while YAML schema files upon conversion are always overwritten, while the manifest isn't. You can either use the `--force` option or just remove files with 'converted' in the file names manually if `fisup` complains.

	fisup test_manifest.yaml

Finally, upon uploading for real, we see output like the following:

```
This is fisup version 0.7, commit a70efdba00aaff8dce42f0a698b8f1af572a5b3f
Target file test_manifest.converted.ttl exists, and force-overwrite (`--force' option) is set, so overwrite
Proceed with loading schema density.yaml
Generating RDF from provided schema
Dumping generated RDF to density.converted.ttl
Successfully dumped generated RDF to density.converted.ttl
Proceed with loading schema sentinel_cages_sampling.yaml
Generating RDF from provided schema
Done generating RDF from provided schema, serialising
Dumping generated RDF to sentinel_cages_sampling.converted.ttl
Successfully dumped generated RDF to sentinel_cages_sampling.converted.ttl
Proceed with loading schema sentinel_cages_sampling.yaml
Generating RDF from provided schema
Done generating RDF from provided schema, serialising
Dumping generated RDF to sentinel_cages_sampling.converted.ttl
Successfully dumped generated RDF to sentinel_cages_sampling.converted.ttl
Proceed with loading schema sentinel_cages_sampling.yaml
Generating RDF from provided schema
Done generating RDF from provided schema, serialising
Dumping generated RDF to sentinel_cages_sampling.converted.ttl
Successfully dumped generated RDF to sentinel_cages_sampling.converted.ttl
Successfully converted all schemata from YAML to TTL
-------------------------------------------------------------------------------------------
| data URI                                     | data schema                  | data hash |
-------------------------------------------------------------------------------------------
| density.csv                                  | density.yaml                 | 1974c2dbe |
| deployment_2011-10-26_2011-11-01_cage_8.csv  | sentinel_cages_sampling.yaml | 0b93c10c8 |
| deployment_2011-10-26_2011-11-01_cage_9.csv  | sentinel_cages_sampling.yaml | 893615354 |
| deployment_2011-10-26_2011-11-01_cage_10.csv | sentinel_cages_sampling.yaml | 5b7548162 |
-------------------------------------------------------------------------------------------
Uploading gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1/test_manifest.yaml ...
Uploaded test_manifest.yaml in 0.28s
Uploading gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1/test_manifest.converted.ttl ...
Uploaded test_manifest.converted.ttl in 0.09s
Uploading gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1/.index ...
Uploaded .index in 0.09s
Uploading gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1/density.csv ...
Uploaded density.csv in 0.09s
Uploading gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1/deployment_2011-10-26_2011-11-01_cage_8.csv ...
Uploaded deployment_2011-10-26_2011-11-01_cage_8.csv in 0.09s
Uploading gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1/deployment_2011-10-26_2011-11-01_cage_9.csv ...
Uploaded deployment_2011-10-26_2011-11-01_cage_9.csv in 0.08s
Uploading gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1/deployment_2011-10-26_2011-11-01_cage_10.csv ...
Uploaded deployment_2011-10-26_2011-11-01_cage_10.csv in 0.08s
Uploading gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1/density.yaml ...
Uploaded density.yaml in 0.08s
Uploading gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1/sentinel_cages_sampling.yaml ...
Uploaded sentinel_cages_sampling.yaml in 0.08s
Uploading gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1/sentinel_cages_sampling.yaml ...
Uploaded sentinel_cages_sampling.yaml in 0.16s
Uploading gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1/sentinel_cages_sampling.yaml ...
Uploaded sentinel_cages_sampling.yaml in 0.09s
Uploading gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1/density.converted.ttl ...
Uploaded density.converted.ttl in 0.09s
Uploading gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1/sentinel_cages_sampling.converted.ttl ...
Uploaded sentinel_cages_sampling.converted.ttl in 0.1s
Uploading gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1/sentinel_cages_sampling.converted.ttl ...
Uploaded sentinel_cages_sampling.converted.ttl in 0.11s
Uploading gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1/sentinel_cages_sampling.converted.ttl ...
Uploaded sentinel_cages_sampling.converted.ttl in 0.09s
Successfully uploaded your data/job set/bundle to gs://saved-rap-test/strathclyde/20240730/538ad90c-4e66-11ef-a43e-f218987e77f1
Result should, within the next 5-10 minutes, appear at https://rap.tardis.ac/saved/rap/538ad90c-4e66-11ef-a43e-f218987e77f1/
```
