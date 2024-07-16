# Fish data utilities overview

As it stands, the fish data utilities work-flow can be summarised as follows:

1. We write **schema** files for data, which are based on [LinkML](https://linkml.io/linkml/)
2. The `fisdat(1)` utility validates and appends metadata to the description manifest, which is a **data** file in YAML or RDF/TTL, the schema of which is the [`job` component of the data model](https://marine.gov.scot/metadata/saved/schema/job.yaml)
3. The data description manifest can be edited to describe jobs to be run on the data
4. Upon upload, the `fisup(1)` utility:
   1. Checks that the referenced data exists, and that the checksum matches
   2. Converts the schema files from YAML to machine-readable RDF/TTL (which can be used independently of the LinkML Python libraries)
   3. Converts the manifest files from YAML to machine-readable RDF/TTL (or vice versa, since we also support creating/editing the manifest in RDF/TTL)
   4. Uploads the set of data files + schema files + manifest to an external storage hosting provider (such as, at the moment Google Cloud)

The main difference between the schema files and the YAML files, then, is that the schema files *describe* data, and are valid LinkML schema files, whereas the manifest files are *data* files which happen to be in YAML format. Editing the files is similar (the syntax is still YAML), but these are not standalone schema files and only a few of the fields valid in LinkML schema files are valid. Simply put, the basic workflow is to generate the manifest files with `fisdat(1)`, perhaps edit the manifest file, then upload the manifest file using `fisup(1)`.
