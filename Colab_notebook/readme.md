# SARC — Multi-Sensor Geospatial Dataset & Analysis Framework

[![Status](https://img.shields.io/badge/Status-Active_Development-blue.svg)](#)
[![Study Region](https://img.shields.io/badge/Region-Teesta_River_Basin%2C_Sikkim-green.svg)](#2-study-area-aoi)
[![CRS](https://img.shields.io/badge/CRS-EPSG%3A32645-orange.svg)](#2-study-area-aoi)
[![Event](https://img.shields.io/badge/Reference_Event-South_Lhonak_GLOF_(Oct_2023)-red.svg)](#1-overview--dataset-inventory)

> **Multi-sensor Earth Observation (EO) framework** integrating Synthetic Aperture Radar (SAR), Digital Elevation Models (DEM), and meteorological satellite data for temporal change analysis, terrain characterization, and atmospheric context in the Teesta River Basin, Eastern Himalayas[cite: 1].

---

## 📋 Table of Contents
1. [Overview & Dataset Inventory](#1-overview--dataset-inventory)
2. [Study Area (AOI)](#2-study-area-aoi)
3. [NISAR — S-band SAR](#3-nisar--s-band-sar)
4. [Sentinel-1 — C-band SAR](#4-sentinel-1--c-band-sar)
5. [CartoDEM — Digital Elevation Model](#5-cartodem--digital-elevation-model)
6. [INSAT-3DR — Meteorological Satellite Data](#6-insat-3dr--meteorological-satellite-data)
7. [Cross-Sensor Harmonization](#7-cross-sensor-harmonization)
8. [Data Sources & References](#8-data-sources--references)
9. [Citation & Scientific Notes](#9-citation--scientific-notes)

---

## 1. Overview & Dataset Inventory

**SARC** combines multi-frequency SAR backscatter, topographic derivatives, and meteorological observations to characterize SAR backscatter variability, investigate historical hydrological events, and analyze landscape dynamics in the Eastern Himalayas[cite: 1].

* **Study Region:** Teesta River Basin, Sikkim, India[cite: 1]
* **Reference Event:** South Lhonak Lake Glacial Lake Outburst Flood (GLOF) — **4 October 2023**[cite: 1]

| Dataset | Satellite / Provider | Product / Sensor Type | Primary Application | Status |
| :--- | :--- | :--- | :--- | :--- |
| **NISAR** | NASA–ISRO[cite: 1] | S-band SAR (`Level-2 GCOV`, `HH/HV`)[cite: 1] | Multi-temporal backscatter, polarimetric feature extraction & anomaly clustering[cite: 1] | `Processed`[cite: 1] |
| **Sentinel-1** | ESA / Copernicus[cite: 1] | C-band SAR (`Level-1 GRD/SLC`, `VV/VH`)[cite: 1] | Historical pre-event & post-event surface change detection[cite: 1] | `Planned`[cite: 1] |
| **CartoDEM** | ISRO / NRSC[cite: 1] | Digital Elevation Model (`30 m`)[cite: 1] | Elevation, slope, aspect, drainage & hydrological connectivity[cite: 1] | `Planned`[cite: 1] |
| **INSAT-3DR** | ISRO / MOSDAC[cite: 1] | Imager & Sounder (`QPE`)[cite: 1] | Quantitative precipitation estimation & atmospheric context[cite: 1] | `Planned`[cite: 1] |

---

## 2. Study Area (AOI)

All datasets are subsetted and co-registered to a compact candidate Area of Interest (AOI) within the Teesta River Basin[cite: 1]. *Spatial coverage must be independently verified for each source dataset prior to multi-sensor integration[cite: 1].*

| Parameter | Value |
| :--- | :--- |
| **Region** | Teesta River Basin, Sikkim, India[cite: 1] |
| **North Bound** | `27.2025° N`[cite: 1] |
| **South Bound** | `27.1575° N`[cite: 1] |
| **West Bound** | `88.4897° E`[cite: 1] |
| **East Bound** | `88.5403° E`[cite: 1] |
| **Projected CRS** | `EPSG:32645` (WGS 84 / UTM zone 45N)[cite: 1] |
| **AOI Subset Dimensions (10 m)** | `508 × 512` pixels (`260,096` total pixels)[cite: 1] |

---

## 3. NISAR — S-band SAR

### Product Specifications
| Parameter | Details |
| :--- | :--- |
| **Mission** | NASA–ISRO Synthetic Aperture Radar (NISAR)[cite: 1] |
| **Sensor Band** | S-band (`frequencyA`)[cite: 1] |
| **Product Level** | Level-2 `GCOV` (Geocoded Polarimetric Covariance)[cite: 1] |
| **File Format** | `HDF5` (`.h5`)[cite: 1] |
| **Polarizations** | `HH`, `HV`[cite: 1] |
| **Orbit / Look Direction** | Ascending / Left-looking[cite: 1] |
| **Track / Frame** | Track `170` / Frame `15`[cite: 1] |
| **CRS & Pixel Spacing** | `EPSG:32645` @ `10 m`[cite: 1] |
| **Full Scene Dimensions** | `33,408 × 34,488` pixels[cite: 1] |

### Acquired Scene Inventory
| Acquisition Date | Track | Frame | Status | Scene Identifier |
| :--- | :--- | :--- | :--- | :--- |
| **24 August 2026** | `170`[cite: 1] | `15`[cite: 1] | Processed for AOI[cite: 1] | `NISAR_S2_PR_GCOV_028_170_A_015_3700_DHNA_A_20260824T233024_233101_P00500_M_F_I_001.h5`[cite: 1] |
| **05 September 2026** | `170`[cite: 1] | `15`[cite: 1] | Processed for AOI[cite: 1] | `NISAR_S2_PR_GCOV_029_170_A_015_3700_DHNA_A_20260905T233024_233100_P00500_M_F_I_001.h5`[cite: 1] |
| **29 September 2026** | `170`[cite: 1] | `15`[cite: 1] | Processed for AOI[cite: 1] | `NISAR_S2_PR_GCOV_031_170_A_015_3700_DHNA_A_20260929T233024_233101_P00500_M_F_I_001.h5`[cite: 1] |

> **⚠️ Temporal Note:** The 2026 NISAR acquisitions represent **later-condition baseline/monitoring observations**[cite: 1]. They do not capture pre-event or immediate post-event states of the October 2023 GLOF[cite: 1].

### Internal HDF5 Structure
Primary HDF5 group path: `/science/SSAR/GCOV/grids/frequencyA/`[cite: 1]

| Dataset | Data Type | Description |
| :--- | :--- | :--- |
| `HHHH`[cite: 1] | `float32`[cite: 1] | HH–HH backscatter covariance[cite: 1] |
| `HVHV`[cite: 1] | `float32`[cite: 1] | HV–HV backscatter covariance[cite: 1] |
| `HHHV`[cite: 1] | `complex64`[cite: 1] | HH–HV cross-covariance[cite: 1] |
| `mask`[cite: 1] | `uint8`[cite: 1] | Subswath validity mask[cite: 1] |
| `inputDataExceptionMask`[cite: 1] | `uint8`[cite: 1] | Input exception flags[cite: 1] |
| `numberOfLooks`[cite: 1] | `float32`[cite: 1] | Number of averaged looks[cite: 1] |
| `rtcGammaToSigmaFactor`[cite: 1] | `float32`[cite: 1] | Radiometric Terrain Correction ($\gamma^0 \rightarrow \sigma^0$) factor[cite: 1] |

### Processing Pipeline & AOI Summary
* **AOI Subset Dimensions:** `508 × 512` pixels (`260,096` total pixels)[cite: 1].
* **Grid Alignment:** All three acquisition dates share an identical spatial grid[cite: 1].
* **Radiometric Normalization:** $\gamma^0$-to-$\sigma^0$ conversion applied using the pixel-wise `rtcGammaToSigmaFactor` layer[cite: 1].
* **Derived Layers:** Temporal stack generated for `HH`, `HV`, and `HH/HV` polarization ratio layers[cite: 1].

---

## 4. Sentinel-1 — C-band SAR

### Planned Specifications
| Parameter | Details |
| :--- | :--- |
| **Mission / Platform** | Copernicus Sentinel-1 (Preferred: `Sentinel-1A`)[cite: 1] |
| **Sensor Band** | C-band[cite: 1] |
| **Product & Mode** | Level-1 `GRD` (Ground Range Detected) & `SLC` — `IW` (Interferometric Wide Swath)[cite: 1] |
| **Polarizations** | `VV`, `VH` (subject to scene availability)[cite: 1] |
| **Target Event** | South Lhonak Lake GLOF (4 October 2023)[cite: 1] |

### Target Search Windows
*Note: Dates below represent catalog search windows, not confirmed scene acquisitions[cite: 1].*

| Category | Search Window | Priority Target Date |
| :--- | :--- | :--- |
| **Pre-event** | `25–30 September 2023`[cite: 1] | `28 September 2023`[cite: 1] |
| **Post-event** | `05–12 October 2023`[cite: 1] | `07 October 2023`[cite: 1] |

### Planned Processing Workflow
1. Verify scene footprint and complete AOI coverage[cite: 1].
2. Validate acquisition geometry, orbit direction, and relative orbit consistency[cite: 1].
3. Apply precise orbit state vectors and thermal/border noise removal[cite: 1].
4. Perform radiometric calibration ($\sigma^0$ or $\gamma^0$)[cite: 1].
5. Evaluate speckle characteristics and apply adaptive filtering if required[cite: 1].
6. Execute Range-Doppler terrain correction and reproject to `EPSG:32645`[cite: 1].
7. Export calibrated `VV` and `VH` analysis layers[cite: 1].

* **Research Role:** Provides C-band event-bracketing observations complementary to NISAR S-band data[cite: 1]. Cross-sensor comparisons will explicitly account for wavelength, polarization (`VV/VH` vs. `HH/HV`), viewing geometry, and spatial resolution differences[cite: 1].

---

## 5. CartoDEM — Digital Elevation Model

### Planned Specifications
| Parameter | Details |
| :--- | :--- |
| **Dataset / Provider** | CartoDEM — National Remote Sensing Centre (NRSC), ISRO[cite: 1] |
| **Target Resolution** | `30 m` posting[cite: 1] |
| **Data Format** | Product-specific format[cite: 1] |

> **Governance Note:** If an alternative DEM (e.g., Copernicus DEM GLO-30 or SRTM) is substituted, its exact source, resolution, vertical datum, and product ID will be documented independently and will **not** be labeled as CartoDEM[cite: 1].

### Planned Terrain Derivatives
* **Morphometry:** Elevation distribution, Slope, Aspect[cite: 1]
* **Hydrology:** Flow direction, Flow accumulation, Drainage network & hydrological connectivity analysis[cite: 1]
* **Exposure Context:** River corridor delineation and settlement proximity analysis[cite: 1]

---

## 6. INSAT-3DR — Meteorological Satellite Data

### Planned Specifications
| Parameter | Details |
| :--- | :--- |
| **Mission / Provider** | INSAT-3DR — Space Applications Centre (SAC), ISRO[cite: 1] |
| **Instrument** | Imager and Sounder[cite: 1] |
| **Data Portal & API** | MOSDAC / MOSDAC MDAPI[cite: 1] |
| **Target Period** | `01–07 October 2023`[cite: 1] |
| **Key Parameter** | Quantitative Precipitation Estimation (`QPE`) & rainfall rate[cite: 1] |

### Pre-Ingestion Verification Checklist
Before integrating any INSAT-3DR product into the pipeline, verify the following metadata attributes[cite: 1]:
- [ ] Exact product and dataset identifier[cite: 1]
- [ ] Target meteorological variable (e.g., rainfall rate / accumulated precipitation)[cite: 1]
- [ ] Spatial coverage, projection, and native grid resolution[cite: 1]
- [ ] Temporal resolution and observation interval[cite: 1]
- [ ] Physical units and scale/offset factors[cite: 1]
- [ ] Quality flags and missing-value (`NoData`) conventions[cite: 1]
- [ ] File format and embedded metadata structure[cite: 1]

---

## 7. Cross-Sensor Harmonization

Because SARC integrates heterogeneous sensors across microwave, topographic, and meteorological domains, datasets are **not directly interchangeable** and require strict harmonization[cite: 1]:

| Sensor / Dataset | Measurement | Key Harmonization Considerations |
| :--- | :--- | :--- |
| **NISAR**[cite: 1] | S-band SAR covariance[cite: 1] | `HH/HV` polarizations, `GCOV` matrix semantics, left-looking geometry[cite: 1] |
| **Sentinel-1**[cite: 1] | C-band SAR backscatter[cite: 1] | `VV/VH` polarizations, `GRD` intensity processing, right-looking geometry[cite: 1] |
| **CartoDEM**[cite: 1] | Surface elevation[cite: 1] | Vertical datum alignment, `30 m` vs. `10 m` resampling, Himalayan layover/shadow artifacts[cite: 1] |
| **INSAT-3DR**[cite: 1] | Atmospheric / rainfall[cite: 1] | Coarse spatial grid, product-specific physical units, sub-daily temporal aggregation[cite: 1] |

---

## 8. Data Sources & References

### NISAR — NASA / ISRO[cite: 1]
1. **ISRO — NISAR S-Band SAR Data Products Release:** https://www.isro.gov.in/NISARS_Band_SAR_Data_Products_Release.html[cite: 1]
2. **ISRO / NRSC — Bhoonidhi Earth Observation Data Hub:** https://bhoonidhi.nrsc.gov.in/[cite: 1]
3. **Bhoonidhi — NISAR Mission and Data Products:** https://bhoonidhi.nrsc.gov.in/NISAR/[cite: 1]
4. **Bhoonidhi — NISAR Product Release Information:** https://bhoonidhi.nrsc.gov.in/NISAR/NisarProducts.html[cite: 1]
5. **NISAR Level-1 and Level-2 Data Product Format Documentation (v1.2.1):** https://bhoonidhi.nrsc.gov.in/NISAR/NISAR_Data_Product_Format_Document_V1.2.1_digisigned.pdf[cite: 1]
6. **NASA — NISAR Mission Overview:** https://science.nasa.gov/mission/nisar/[cite: 1]

### Sentinel-1 — ESA / Copernicus[cite: 1]
1. **Copernicus Data Space Ecosystem — Sentinel-1 Data Collection:** https://dataspace.copernicus.eu/data-collections/copernicus-sentinel-missions/sentinel-1[cite: 1]
2. **Copernicus Data Space — Sentinel-1 Technical Documentation:** https://documentation.dataspace.copernicus.eu/Data/Sentinel1.html[cite: 1]
3. **Copernicus Sentinel Online:** https://sentinels.copernicus.eu/[cite: 1]

### CartoDEM — ISRO / NRSC[cite: 1]
1. **NRSC — CartoDEM Product Information:** https://www.nrsc.gov.in/nrscnew/Dataproducts_Thematic_cartodem.php?lang_code=en[cite: 1]
2. **ISRO / NRSC — Bhoonidhi Data Hub:** https://bhoonidhi.nrsc.gov.in/[cite: 1]

### INSAT-3DR — ISRO / MOSDAC[cite: 1]
1. **MOSDAC — INSAT-3DR Mission Overview:** https://www.mosdac.gov.in/insat-3dr-introduction[cite: 1]
2. **MOSDAC — INSAT-3DR Data Products:** https://www.mosdac.gov.in/insat-3dr-data-products[cite: 1]
3. **MOSDAC — INSAT-3DR Mission and Data Portal:** https://mosdac.gov.in/insat-3dr[cite: 1]
4. **ISRO — MOSDAC Institutional Overview:** https://www.isro.gov.in/ISRO_EN/MOSDAC.html[cite: 1]
5. **MOSDAC — Quantitative Precipitation and Related Data Catalogue:** https://mosdac.gov.in/[cite: 1]

### Geospatial & Scientific Processing Libraries[cite: 1]
* **GDAL:** https://gdal.org/ | **Rasterio:** https://rasterio.readthedocs.io/ | **GeoPandas:** https://geopandas.org/[cite: 1]
* **NumPy:** https://numpy.org/doc/ | **SciPy:** https://docs.scipy.org/doc/scipy/ | **Pandas:** https://pandas.pydata.org/docs/ | **Scikit-learn:** https://scikit-learn.org/stable/[cite: 1]

---

## 9. Citation & Scientific Notes

* **Reference & Interpretation Note:** Mission portals and product documentation are used to establish sensor characteristics, product definitions, processing levels, and data specifications[cite: 1]. Scientific interpretations derived from SARC processing are based on the corresponding input observations and analytical outputs; product documentation alone does not constitute validation of a detected environmental event[cite: 1].
* **Citation Convention:** Dataset-specific publications, product versions, acquisition identifiers, and processing parameters should be cited alongside the corresponding analysis whenever results are published or presented[cite: 1].
