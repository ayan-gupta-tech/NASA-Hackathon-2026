# SARC — Multi-Sensor Geospatial Dataset Documentation

[![Status](https://img.shields.io/badge/Status-Active_Development-blue)]()
[![Study Region](https://img.shields.io/badge/Region-Teesta_River_Basin%2C_Sikkim-green)]()
[![CRS](https://img.shields.io/badge/CRS-EPSG%3A32645-orange)]()
[![NISAR](https://img.shields.io/badge/NISAR-3_Scenes_Acquired-brightgreen)]()

> **Project Focus:** Multi-sensor Earth Observation (EO) framework integrating Synthetic Aperture Radar (SAR), Digital Elevation Models (DEM), and meteorological satellite data for temporal change analysis, terrain characterization, and atmospheric context in the Teesta River Basin.

---

## 📋 Table of Contents
1. [Dataset Overview](#1-dataset-overview)
2. [Common Study Area (AOI)](#2-common-study-area-aoi)
3. [NISAR — S-band SAR](#3-nisar--s-band-sar)
4. [Sentinel-1 — C-band SAR](#4-sentinel-1--c-band-sar)
5. [CartoDEM — Digital Elevation Model](#5-cartodem--digital-elevation-model)
6. [INSAT-3DR — Meteorological Satellite Data](#6-insat-3dr--meteorological-satellite-data)
7. [Cross-Sensor Data Considerations](#7-cross-sensor-data-considerations)
8. [Dataset Status Summary](#8-dataset-status-summary)
9. [Data Sources & References](#9-data-sources--references)

---

## 1. Dataset Overview

**SARC** combines multi-frequency SAR backscatter, topographic derivatives, and meteorological observations to analyze landscape dynamics and hydrological hazards in the Eastern Himalayas.

* **Study Region:** Teesta River Basin, Sikkim, India
* **Reference Event:** South Lhonak Lake Glacial Lake Outburst Flood (GLOF) — **4 October 2023**

| Dataset | Platform / Mission | Data Type | Primary Purpose | Status |
| :--- | :--- | :--- | :--- | :--- |
| **NISAR** | NASA–ISRO | S-band SAR (`GCOV`) | Polarimetric backscatter & temporal analysis | ✅ **Acquired (3 scenes)** |
| **Sentinel-1** | ESA / Copernicus | C-band SAR (`GRD`) | Pre-event & post-event radar observations | ⏳ *Pending acquisition* |
| **CartoDEM** | ISRO | Digital Elevation Model | Terrain, elevation & drainage analysis | ⏳ *Pending acquisition* |
| **INSAT-3DR** | ISRO / MOSDAC | Meteorological satellite | Rainfall & atmospheric context | ⏳ *Pending acquisition* |

---

## 2. Common Study Area (AOI)

All datasets are subsetted and co-registered to a compact candidate Area of Interest (AOI) within the Teesta River Basin. *Spatial coverage must be independently verified for each source dataset prior to multi-sensor integration.*

| Boundary / Parameter | Value |
| :--- | :--- |
| **North** | `27.2025° N` |
| **South** | `27.1575° N` |
| **West** | `88.4897° E` |
| **East** | `88.5403° E` |
| **Projected CRS** | `EPSG:32645` (WGS 84 / UTM zone 45N) |
| **Region** | Teesta River Basin, Sikkim |

---

## 3. NISAR — S-band SAR

### Product Specifications
| Parameter | Details |
| :--- | :--- |
| **Mission** | NASA–ISRO Synthetic Aperture Radar (NISAR) |
| **Sensor Band** | S-band |
| **Product Level** | `GCOV` (Geocoded Polarimetric Covariance) |
| **File Format** | `HDF5` (`.h5`) |
| **Frequency Group** | `frequencyA` |
| **Polarizations** | `HH`, `HV` |
| **Orbit / Look Direction** | Ascending / Left-looking |
| **Track / Frame** | Track `170` / Frame `15` |
| **CRS & Pixel Spacing** | `EPSG:32645` @ `10 m` |
| **Full Scene Dimensions** | `33,408 × 34,488` pixels |

### Acquired Scenes
| Acquisition Date | Track | Frame | Status |
| :--- | :--- | :--- | :--- |
| **24 August 2026** | 170 | 15 | Processed for AOI |
| **05 September 2026** | 170 | 15 | Processed for AOI |
| **29 September 2026** | 170 | 15 | Processed for AOI |

> **⚠️ Temporal Note:** The 2026 NISAR acquisitions represent **later-condition baseline/monitoring observations**. They do not capture pre-event or immediate post-event states of the October 2023 GLOF.

### Internal HDF5 Structure
Primary HDF5 group path: `/science/SSAR/GCOV/grids/frequencyA/`

| Dataset | Data Type | Description |
| :--- | :--- | :--- |
| `HHHH` | `float32` | HH–HH backscatter covariance |
| `HVHV` | `float32` | HV–HV backscatter covariance |
| `HHHV` | `complex64` | HH–HV cross-covariance |
| `mask` | `uint8` | Subswath validity mask |
| `inputDataExceptionMask` | `uint8` | Input exception flags |
| `numberOfLooks` | `float32` | Number of averaged looks |
| `rtcGammaToSigmaFactor` | `float32` | Radiometric Terrain Correction ($\gamma^0 \rightarrow \sigma^0$) factor |

### Processing Pipeline & AOI Summary
* **AOI Subset Dimensions:** `508 × 512` pixels (`260,096` total pixels)
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
| **Product & Mode** | Level-1 `GRD` (Ground Range Detected) — `IW` (Interferometric Wide Swath) |
| **Polarizations** | `VV`, `VH` |
| **Target Event** | South Lhonak GLOF (4 October 2023) |

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
| **Dataset / Provider** | CartoDEM (ISRO) |
| **Target Resolution** | `30 m` |
| **Data Format** | *To be confirmed upon download* |
| **Status** | ⏳ Pending acquisition |

> **Governance Note:** If an alternative DEM (e.g., Copernicus DEM GLO-30 or SRTM) is substituted, its exact source, resolution, vertical datum, and product ID will be documented independently and will **not** be labeled as CartoDEM.

### Planned Terrain Derivatives
* **Morphometry:** Elevation distribution, Slope, Aspect
* **Hydrology:** Flow direction, Flow accumulation, Drainage network extraction
* **Exposure Context:** River corridor delineation and settlement proximity analysis

---

## 6. INSAT-3DR — Meteorological Satellite Data

### Planned Specifications
| Parameter | Details |
| :--- | :--- |
| **Mission / Provider** | INSAT-3DR (ISRO) |
| **Data Portal & API** | MOSDAC / MOSDAC MDAPI |
| **Target Period** | `01–07 October 2023` |
| **Product Identifier** | *Pending MOSDAC catalog verification* |
| **Status** | ⏳ Pending catalog discovery & download |

### Pre-Ingestion Verification Checklist
Before integrating any INSAT-3DR product into the pipeline, the following metadata attributes must be verified:
- [ ] Exact product and dataset identifier
- [ ] Target meteorological variable (e.g., rainfall rate / accumulated precipitation)
- [ ] Spatial coverage, projection, and native grid resolution
- [ ] Temporal resolution and observation interval
- [ ] Physical units and scale/offset factors
- [ ] Quality flags and missing-value (`NoData`) conventions
- [ ] File format and embedded metadata structure

---

## 7. Cross-Sensor Data Considerations

Because SARC integrates heterogeneous sensors across microwave, optical/elevation, and meteorological domains, datasets are **not directly interchangeable** and require strict harmonization:

| Sensor / Dataset | Measurement | Key Harmonization Considerations |
| :--- | :--- | :--- |
| **NISAR** | S-band SAR covariance | `HH/HV` polarizations, `GCOV` matrix semantics, left-looking geometry |
| **Sentinel-1** | C-band SAR backscatter | `VV/VH` polarizations, `GRD` intensity processing, right-looking geometry |
| **CartoDEM** | Surface elevation | Vertical datum alignment, `30 m` vs. `10 m` resampling, Himalayan layover/shadow artifacts |
| **INSAT-3DR** | Atmospheric/rainfall | Coarse spatial grid, product-specific physical units, sub-daily temporal aggregation |

---

## 8. Dataset Status Summary

*Exact file sizes, granule names, product IDs, and orbit metadata for pending datasets will be appended upon download and inspection.*

| Dataset | Acquisitions / Products | Current Status |
| :--- | :--- | :--- |
| **NISAR** | 3 HDF5 (`GCOV`) scenes | ✅ **Acquired & processed for AOI** |
| **Sentinel-1** | Level
