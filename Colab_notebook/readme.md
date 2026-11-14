# SARC — Multi-Sensor Geospatial Dataset & Analysis Framework

[![Status](https://img.shields.io/badge/Status-Active_Development-blue.svg)](#)
[![Study Region](https://img.shields.io/badge/Region-Teesta_River_Basin%2C_Sikkim-green.svg)](#2-study-area-aoi)
[![CRS](https://img.shields.io/badge/CRS-EPSG%3A32645-orange.svg)](#2-study-area-aoi)
[![Event](https://img.shields.io/badge/Reference_Event-South_Lhonak_GLOF_(Oct_2023)-red.svg)](#1-overview--dataset-inventory)

> **Multi-sensor Earth Observation (EO) framework** integrating Synthetic Aperture Radar (SAR), Digital Elevation Models (DEM), and meteorological satellite data for temporal change analysis, terrain characterization, and atmospheric context in the Teesta River Basin, Eastern Himalayas.

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


---

## 1. Overview & Dataset Inventory

**SARC** combines multi-frequency SAR backscatter, topographic derivatives, and meteorological observations to characterize SAR backscatter variability, investigate historical hydrological events, and analyze landscape dynamics in the Eastern Himalayas.

* **Study Region:** Teesta River Basin, Sikkim, India
* **Reference Event:** South Lhonak Lake Glacial Lake Outburst Flood (GLOF) — **4 October 2023**

| Dataset | Satellite / Provider | Product / Sensor Type | Primary Application | Status |
| :--- | :--- | :--- | :--- | :--- |
| **NISAR** | NASA–ISRO | S-band SAR (`Level-2 GCOV`, `HH/HV`) | Multi-temporal backscatter, polarimetric feature extraction & anomaly clustering | `Processed`|
| **Sentinel-1** | ESA / Copernicus | C-band SAR (`Level-1 GRD/SLC`, `VV/VH`) | Historical pre-event & post-event surface change detection | `Planned`|
| **CartoDEM** | ISRO / NRSC | Digital Elevation Model (`30 m`) | Elevation, slope, aspect, drainage & hydrological connectivity | `Planned`|
| **INSAT-3DR** | ISRO / MOSDAC | Imager & Sounder (`QPE`) | Quantitative precipitation estimation & atmospheric context | `Planned` |

---

## 2. Study Area (AOI)

All datasets are subsetted and co-registered to a compact candidate Area of Interest (AOI) within the Teesta River Basin. *Spatial coverage must be independently verified for each source dataset prior to multi-sensor integration.*

| Parameter | Value |
| :--- | :--- |
| **Region** | Teesta River Basin, Sikkim, India |
| **North Bound** | `27.2025° N` |
| **South Bound** | `27.1575° N` |
| **West Bound** | `88.4897° E` |
| **East Bound** | `88.5403° E` |
| **Projected CRS** | `EPSG:32645` (WGS 84 / UTM zone 45N) |
| **AOI Subset Dimensions (10 m)** | `508 × 512` pixels (`260,096` total pixels)|

---

## 3. NISAR — S-band SAR

### Product Specifications
| Parameter | Details |
| :--- | :--- |
| **Mission** | NASA–ISRO Synthetic Aperture Radar (NISAR) |
| **Sensor Band** | S-band (`frequencyA`) |
| **Product Level** | Level-2 `GCOV` (Geocoded Polarimetric Covariance) |
| **File Format** | `HDF5` (`.h5`) |
| **Polarizations** | `HH`, `HV` |
| **Orbit / Look Direction** | Ascending / Left-looking |
| **Track / Frame** | Track `170` / Frame `15` |
| **CRS & Pixel Spacing** | `EPSG:32645` @ `10 m` |
| **Full Scene Dimensions** | `33,408 × 34,488` pixels |

### Acquired Scene Inventory
| Acquisition Date | Track | Frame | Status | Scene Identifier |
| :--- | :--- | :--- | :--- | :--- |
| **24 August 2026** | `170` | `15` | Processed for AOI | `NISAR_S2_PR_GCOV_028_170_A_015_3700_DHNA_A_20260824T233024_233101_P00500_M_F_I_001.h5` |
| **05 September 2026** | `170` | `15` | Processed for AOI | `NISAR_S2_PR_GCOV_029_170_A_015_3700_DHNA_A_20260905T233024_233100_P00500_M_F_I_001.h5` |
| **29 September 2026** | `170` | `15` | Processed for AOI | `NISAR_S2_PR_GCOV_031_170_A_015_3700_DHNA_A_20260929T233024_233101_P00500_M_F_I_001.h5` |

> **⚠️ Temporal Note:** The 2026 NISAR acquisitions represent **later-condition baseline/monitoring observations**. They do not capture pre-event or immediate post-event states of the October 2023 GLOF.

### Internal HDF5 Structure
Primary HDF5 group path: `/science/SSAR/GCOV/grids/frequencyA/`

| Dataset | Data Type | Description |
| :--- | :--- | :--- |
| `HHHH` | `float32` | HH–HH backscatter covariance |
| `HVHV` | `float32`| HV–HV backscatter covariance |
| `HHHV` | `complex64` | HH–HV cross-covariance |
| `mask` | `uint8` | Subswath validity mask|
| `inputDataExceptionMask` | `uint8` | Input exception flags|
| `numberOfLooks` | `float32` | Number of averaged looks |
| `rtcGammaToSigmaFactor` | `float32` | Radiometric Terrain Correction ($\gamma^0 \rightarrow \sigma^0$) factor |

### Processing Pipeline & AOI Summary
* **AOI Subset Dimensions:** `508 × 512` pixels (`260,096` total pixels).
* **Grid Alignment:** All three acquisition dates share an identical spatial grid.
* **Radiometric Normalization:** $\gamma^0$-to-$\sigma^0$ conversion applied using the pixel-wise `rtcGammaToSigmaFactor` layer.
* **Derived Layers:** Temporal stack generated for `HH`, `HV`, and `HH/HV` polarization ratio layers.

---

## 4. Sentinel-1 — C-band SAR

### Planned Specifications
| Parameter | Details |
| :--- | :--- |
| **Mission / Platform** | Copernicus Sentinel-1 (Preferred: `Sentinel-1A`) |
| **Sensor Band** | C-band |
| **Product & Mode** | Level-1 `GRD` (Ground Range Detected) & `SLC` — `IW` (Interferometric Wide Swath) |
| **Polarizations** | `VV`, `VH` (subject to scene availability) |
| **Target Event** | South Lhonak Lake GLOF (4 October 2023) |

### Target Search Windows
*Note: Dates below represent catalog search windows, not confirmed scene acquisitions.*

| Category | Search Window | Priority Target Date |
| :--- | :--- | :--- |
| **Pre-event** | `25–30 September 2023` | `28 September 2023` |
| **Post-event** | `05–12 October 2023` | `07 October 2023` |

### Planned Processing Workflow
1. Verify scene footprint and complete AOI coverage.
2. Validate acquisition geometry, orbit direction, and relative orbit consistency.
3. Apply precise orbit state vectors and thermal/border noise removal.
4. Perform radiometric calibration ($\sigma^0$ or $\gamma^0$).
5. Evaluate speckle characteristics and apply adaptive filtering if required.
6. Execute Range-Doppler terrain correction and reproject to `EPSG:32645`.
7. Export calibrated `VV` and `VH` analysis layers.

* **Research Role:** Provides C-band event-bracketing observations complementary to NISAR S-band data. Cross-sensor comparisons will explicitly account for wavelength, polarization (`VV/VH` vs. `HH/HV`), viewing geometry, and spatial resolution differences.

---

## 5. CartoDEM — Digital Elevation Model

### Planned Specifications
| Parameter | Details |
| :--- | :--- |
| **Dataset / Provider** | CartoDEM — National Remote Sensing Centre (NRSC), ISRO |
| **Target Resolution** | `30 m` posting |
| **Data Format** | Product-specific format |

> **Governance Note:** If an alternative DEM (e.g., Copernicus DEM GLO-30 or SRTM) is substituted, its exact source, resolution, vertical datum, and product ID will be documented independently and will **not** be labeled as CartoDEM.

### Planned Terrain Derivatives
* **Morphometry:** Elevation distribution, Slope, Aspect
* **Hydrology:** Flow direction, Flow accumulation, Drainage network & hydrological connectivity analysis
* **Exposure Context:** River corridor delineation and settlement proximity analysis
---

## 6. INSAT-3DR — Meteorological Satellite Data

### Planned Specifications
| Parameter | Details |
| :--- | :--- |
| **Mission / Provider** | INSAT-3DR — Space Applications Centre (SAC), ISRO |
| **Instrument** | Imager and Sounder |
| **Data Portal & API** | MOSDAC / MOSDAC MDAPI |
| **Target Period** | `01–07 October 2023` |
| **Key Parameter** | Quantitative Precipitation Estimation (`QPE`) & rainfall rate |

### Pre-Ingestion Verification Checklist
Before integrating any INSAT-3DR product into the pipeline, verify the following metadata attributes:
- [ ] Exact product and dataset identifier
- [ ] Target meteorological variable (e.g., rainfall rate / accumulated precipitation)
- [ ] Spatial coverage, projection, and native grid resolution
- [ ] Temporal resolution and observation interval
- [ ] Physical units and scale/offset factors
- [ ] Quality flags and missing-value (`NoData`) conventions
- [ ] File format and embedded metadata structure

---

## 7. Cross-Sensor Harmonization

Because SARC integrates heterogeneous sensors across microwave, topographic, and meteorological domains, datasets are **not directly interchangeable** and require strict harmonization:

| Sensor / Dataset | Measurement | Key Harmonization Considerations |
| :--- | :--- | :--- |
| **NISAR** | S-band SAR covariance | `HH/HV` polarizations, `GCOV` matrix semantics, left-looking geometry |
| **Sentinel-1** | C-band SAR backscatter | `VV/VH` polarizations, `GRD` intensity processing, right-looking geometry |
| **CartoDEM** | Surface elevation | Vertical datum alignment, `30 m` vs. `10 m` resampling, Himalayan layover/shadow artifacts |
| **INSAT-3DR** | Atmospheric / rainfall | Coarse spatial grid, product-specific physical units, sub-daily temporal aggregation |

---

## 8. Data Sources & References

### NISAR — NASA / ISRO
1. **ISRO — NISAR S-Band SAR Data Products Release:** https://www.isro.gov.in/NISARS_Band_SAR_Data_Products_Release.html
2. **ISRO / NRSC — Bhoonidhi Earth Observation Data Hub:** https://bhoonidhi.nrsc.gov.in/
3. **Bhoonidhi — NISAR Mission and Data Products:** https://bhoonidhi.nrsc.gov.in/NISAR/
4. **Bhoonidhi — NISAR Product Release Information:** https://bhoonidhi.nrsc.gov.in/NISAR/NisarProducts.html
5. **NISAR Level-1 and Level-2 Data Product Format Documentation (v1.2.1):** https://bhoonidhi.nrsc.gov.in/NISAR/NISAR_Data_Product_Format_Document_V1.2.1_digisigned.pdf
6. **NASA — NISAR Mission Overview:** https://science.nasa.gov/mission/nisar/

### Sentinel-1 — ESA / Copernicus
1. **Copernicus Data Space Ecosystem — Sentinel-1 Data Collection:** https://dataspace.copernicus.eu/data-collections/copernicus-sentinel-missions/sentinel-1
2. **Copernicus Data Space — Sentinel-1 Technical Documentation:** https://documentation.dataspace.copernicus.eu/Data/Sentinel1.html
3. **Copernicus Sentinel Online:** https://sentinels.copernicus.eu/

### CartoDEM — ISRO / NRSC
1. **NRSC — CartoDEM Product Information:** https://www.nrsc.gov.in/nrscnew/Dataproducts_Thematic_cartodem.php?lang_code=en
2. **ISRO / NRSC — Bhoonidhi Data Hub:** https://bhoonidhi.nrsc.gov.in/

### INSAT-3DR — ISRO / MOSDAC
1. **MOSDAC — INSAT-3DR Mission Overview:** https://www.mosdac.gov.in/insat-3dr-introduction
2. **MOSDAC — INSAT-3DR Data Products:** https://www.mosdac.gov.in/insat-3dr-data-products
3. **MOSDAC — INSAT-3DR Mission and Data Portal:** https://mosdac.gov.in/insat-3dr
4. **ISRO — MOSDAC Institutional Overview:** https://www.isro.gov.in/ISRO_EN/MOSDAC.html
5. **MOSDAC — Quantitative Precipitation and Related Data Catalogue:** https://mosdac.gov.in/

### Geospatial & Scientific Processing Libraries
* **GDAL:** https://gdal.org/ | **Rasterio:** https://rasterio.readthedocs.io/ | **GeoPandas:** https://geopandas.org/
* **NumPy:** https://numpy.org/doc/ | **SciPy:** https://docs.scipy.org/doc/scipy/ | **Pandas:** https://pandas.pydata.org/docs/ | **Scikit-learn:** https://scikit-learn.org/stable/

---


