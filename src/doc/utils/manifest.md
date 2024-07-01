# The manifest

## Outline

One might generate a schema in the `examples/sentinel_cages` directory as follows:

```sh
% fisdat sentinel_cages_site.yaml Sentinel_cage_station_info_6.csv  my_manifest.yaml
% fisdat sentinel_cages_sampling.yaml sentinel_cages_cleaned.csv  my_manifest.yaml
% fisup my_manifest.yaml
```

## Declaring jobs
### The generated example job
If you've had a look at the generated manifest files, you may have noticed that it generates an example/empty job when the utility first creates the manifest file (additional example jobs aren't appended to the file when appending more data). In YAML, the example/empty job has the following form:

```yaml
jobs:
- atomic_name: job_example_sentinel_cages_cleaned
  job_type:    ignore
  title:       Empty job template for sentinel_cages_cleaned
```

The design of this section is not specific to any job. The data model does not know anything about the structure of a job, or what it runs. All it knows about is the following attributes:

1. [`atomic_name`](https://marine.gov.scot/metadata/saved/schema/atomic_name/): This is an identifier for the job description. Recall that an 'atom' is a text string with no spaces, underscores are the only valid control characters. It must be unique, indeed, it gets transformed into the identifier for the job (a URI) in RDF/TTL.
2. [`job_type`](https://marine.gov.scot/metadata/saved/schema/job_type/): This is the "type" of the job and the data model has a notion of valid jobs. At the moment, these are "ignore" and "density".
3. [`title`](https://marine.gov.scot/metadata/saved/schema/title/): A free-text title of the job. Keep it relatively short like the `title` field in the YAML schemata. Longer descriptions should go in the [`description`](https://marine.gov.scot/metadata/saved/schema/description/) field.

### Additional attributes

There are several other fields supported here:

1. [`description`](https://marine.gov.scot/metadata/saved/schema/description/): Longer free-text description of the job. Both this and title are a key part of the feedback at the end of the pipeline, and will be included in the generated results (web pages).
2. [`job_scope_descriptive`](https://marine.gov.scot/metadata/saved/schema/job_scope_descriptive/): A list of column mappings to bring into scope, the provenance of which is notionally that they describe data about the world (e.g. latitude, longitude, data sampling notes).
3. [`job_scope_collected`](https://marine.gov.scot/metadata/saved/schema/job_scope_collected/): A list of column mappings to bring into scope, the provenance of which is notionally that they describe data which has been collected, or sampled, from the environment.
4. [`job_scope_modelled`](https://marine.gov.scot/metadata/saved/schema/job_scope_modelled/): A list of column mappings to bring into scope, the provenance of which is notionally that they describe data which has been mod, or simulated.

Column mappings to bring into scope for the job are specified in the same way for each type, with the following fields necessary:
1. [`column`](https://marine.gov.scot/metadata/saved/schema/column/): The verbatim column name in the table/data file in question, e.g. `TOTAL`
2. [`table`](https://marine.gov.scot/metadata/saved/schema/table/): The name of the table object (specifically, the `atomic_name` field) in the manifest file which contains the column, e.g. `sampling`. It is likely that when comparing data, the source columns are included in different files.
3. [`variable`](https://marine.gov.scot/metadata/saved/schema/variable/): The **underlying** variable in the SAVED data model, e.g. [`saved:lice_af_total`](https://marine.gov.scot/metadata/saved/schema/lice_af_total/). Making sure that this is the variable which the job in question is able to process is important, as it is how subsequent processing of the job proper is able to identify the variable to which the column actually refers.

In effect, what we are doing here is columns to data files, and to an underlying variable in the data model, which we have ostensibly agreed describes something across models. This lets us run jobs on generic data with arbitrary column names, which reflects quite well what we encounter in practice, particularly when sharing data. The neat thing about this approach is it really emerges naturally from the notion that we should link variables in data files to variables in the data model.

### Density example

```yaml
atomic_name: RootManifest
tables:
- atomic_name: time_density_simple
  resource_path: density.csv
  resource_hash: 1974c2dbefaeaaa425a789142e405f7b8074bb96348b24003fe36bf4098e6b58e2227680bcf72634c4553b214f33acb4
  schema_path_yaml: density.yaml
  title: placeholder time/density description
  description: ''
- atomic_name: sampling
  resource_path: cagedata-10.csv
  resource_hash: 338279e44840d693ce184ef672c430c8cf0d26bc4ca4ca968429f0b3b472685f5410d78ab808b102f1f37148020b4d0c
  schema_path_yaml: sentinel_cages_sampling.yaml
  title: Sentinel cages sampling information schema
  description: ''
jobs:
- atomic_name: job_example_time_density_simple
  job_type: density
  title: Example job time_density_simple
  job_scope_collected:
    - column: TOTAL
      table:  sampling
      variable: saved:lice_af_total
  job_scope_modelled:
    - column: time
      table: time_density_simple
      variable: saved:time
    - column: density
      table: time_density_simple
      variable: saved:lice_density_modelled
local_version: 0.5
```
The manifest itself has an [`atomic_name`](https://marine.gov.scot/metadata/saved/schema/atomic_name/) identifier. This is by default `RootManifest`, and you should change this. What does this mean in practice?

- Recall that when writing schema files for our data, we had to declare a prefix to be used for the schema.
- When serialising manifests as RDF/TTL (with the `--manifest-format ttl`  option in `fisdat(1)`, and/or during the conversion upon upload), there is a so-called 'base' prefix which uses these identifiers. This is by default `https://marine.gov.scot/metadata/saved/rap/`.
- Currently, there isn't a check on whether the expanded identifier, based on this [`atomic_name`](https://marine.gov.scot/metadata/saved/schema/atomic_name/) attribute and the 'base' prefix (the default would thus be `https://marine.gov.scot/metadata/saved/rap/RootManifest`) is already in use, but there could be in the future. 
- Making the name of the serialised manifest, unique then, involves either changing the 'base' prefix to something else (e.g. `https://marine.gov.scot/metadata/saved/rap/job_20240627/`, using the `--base-prefix <some_prefix>` CLI option), varying the name of the manifest in this file (e.g. to `Manifest20240627`), or some combination of the two. 
- Since the aim is to link data together, including results, it's worth thinking about this carefully. Varying the 'base' prefix is desirable in the sense that not everyone is Marine Scotland, so would have a different place to eventually put generated results.

Other things to consider:

- The [`tables`](https://marine.gov.scot/metadata/saved/schema/tables/) and [`jobs`](https://marine.gov.scot/metadata/saved/schema/jobs/) sections are lists. Note the dash before the start of a new element in the list, where indentation indicates that these list items are part of the same block.
- In general, do not edit the [`tables`](https://marine.gov.scot/metadata/saved/schema/tables/) section, since these are created by the `fisdat(1)` tool, and upload/subsequent job processing may fail if this section is invalid. In both these lists, what makes elements unique is the [`atomic_name`](https://marine.gov.scot/metadata/saved/schema/atomic_name/) identifier.
- There is a single job declared here, but more than one job could be requested in a single manifest file. Whether to create multiple manifests for multiple jobs may depend on the cost of uploading data, which may be large.

## YAML vs RDF/TTL

By default, the `fisdat(1)` tool appends to manifest files in the YAML format, and the `fisup(1)` program, prior to upload, converts these to RDF/TTL upon upload. It is possible, using the `--manifest-format` (`-f` for short) option, to instead specify "ttl" as the format, each time one runs `fisdat(1)`. When using this option, and using it with `fisup(1)`, the conversion upon upload is to YAML, so that both formats are available to whatever does the subsequent processing.

There is a further option to debug the conversion between YAML and the equivalent RDF/TTL representation of the manifest, which is the `fisjob(1)` program. This takes a manifest file in RDF/TTL, and converts it to YAML (using the `from-manifest` option) or takes a manifest file in YAML, and converts it (using the `from-template` option). This largely serves to convert the manifest itself, whereas running `fisup(1)` with the `--no-upload` option largely performs the same thing, albeit also converts the schema files from LinkML YAML schema files to RDF/TTL.

For the schema files, these are also in YAML format, but they are standalone schema files *using the LinkML data model*, whereas the manifest files are *data* files processed by LinkML. The conversion from the fields in the YAML data files to an RDF graph is more or less 1:1. In contrast, the RDF/TTL equivalent of the LinkML schema files are very complicated, using identifiers from a number of ontologies / data models (such as [FOAF](http://xmlns.com/foaf/spec/), [SKOS](https://www.w3.org/TR/skos-reference/) and [Dublin Core](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/)). Therefore, there is no way to write an RDF/TTL equivalent of these LinkML YAML schema files by hand, even if the RDF/TTL equivalent is largely readable. Therefore, schema files are always in YAML format and are converted to RDF/TTL by `fisup(1)` alone, and the `fisjob(1)` program does not touch these.

The command line interface is largely similar for all three tools, e.g. the `fisjob(1)` program still requires a 'base' prefix (with the same default `https://marine.gov.scot/metadata/saved/rap/` as default)
