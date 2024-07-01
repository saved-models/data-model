# Documentation for SAVED

## The pipeline step-by-step

| *Step* | *Operation*                                        | *Location*                                                |
|--------|----------------------------------------------------|-----------------------------------------------------------|
| 0.1    | Modelling strategy                                 | Local machine                                             |
| 0.2    | Preparation/clean-up                               | Local machine                                             |
| 1      | Verify schema, create job manifest (incl. UUID)    | Local machine: existing Python program                    |
| 2      | Upload job data-set to storage service             | Local machine: albeit depends on external storage service |
| 3      | Append job metadata to queue and local DB          | RAP service: monitor storage for changes                  |
| 4      | Fetch data required by job(s)                      | RAP service: pull any changes from storage                |
| 5      | Run job(s)                                         | RAP service                                               |
| 6      | Cache result(s) and/or data-set                    | RAP service                                               |
| 7      | Generate HTML results incl. any errors + descriptive statistics/visualisations applicable | RAP service and/or external web server |
