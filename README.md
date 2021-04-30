
[![img](https://img.shields.io/badge/Lifecycle-Stable-97ca00)](https://github.com/bcgov/repomountie/blob/master/doc/lifecycle-badges.md)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)



hydrometric_stations
============================

### Usage

Process used to create the [*Hydrometric Stations - Active and Discontinued*](https://catalogue.data.gov.bc.ca/dataset/hydrometric-stations-active-and-discontinued) data object in the [BC Data Catalogue](https://catalogue.data.gov.bc.ca/dataset). The repository outlines the process used in R with the [tidyhydat](https://CRAN.R-project.org/package=tidyhydat) and [bcdata](https://CRAN.R-project.org/package=bcdata) packages to create the data object.

### Project Status
Updated with each quarterly release of [HYDAT](https://ec.gc.ca/rhc-wsc/default.asp?n=9018B5EC-1), the Environment and Climate Change Canada database of hydrometric data.  

### Usage
This data can be retrieved through the BC Data Catalogue or using the bcdata R package:

```
library(bcdata)
bcdc_get_data('4c169515-6c41-4f6a-bd30-19a1f45cad1f')
```

### Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an [issue](https://github.com/bcgov/hydrometric_stations/issues/).

### How to Contribute

If you would like to contribute, please see our [CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

### License

```
Copyright 2018 Province of British Columbia

Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
```
---
*This project was created using the [bcgovr](https://github.com/bcgov/bcgovr) package.* 
