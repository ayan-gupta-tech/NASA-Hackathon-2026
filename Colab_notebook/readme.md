# SARC — Multi-Sensor Geospatial Dataset & Analysis Framework

[![Status](https://img.shields.io/badge/Status-Active_Development-blue.svg)](#)
[![Study Region](https://img.shields.io/badge/Region-Teesta_River_Basin%2C_Sikkim-green.svg)](#2-study-area-aoi)
[![CRS](https://img.shields.io/badge/CRS-EPSG%3A32645-orange.svg)](#2-study-area-aoi)
[![Event](https://img.shields.io/badge/Reference_Event-South_Lhonak_GLOF_(Oct_2023)-red.svg)](#1-overview--dataset-inventory)

> **Multi-sensor Earth Observation (EO) framework** integrating Synthetic Aperture Radar (SAR), Digital Elevation Models (DEM), and planned meteorological satellite data for temporal backscatter analysis, terrain correction, geospatial change characterization, and environmental monitoring in the Teesta River Basin, Eastern Himalayas.

---

## 📋 Table of Contents

1. [Overview & Dataset Inventory](#1-overview--dataset-inventory)
2. [Study Area (AOI)](#2-study-area-aoi)
3. [NISAR — S-band SAR](#3-nisar--s-band-sar)
4. [Sentinel-1 — C-band SAR](#4-sentinel-1--c-band-sar)
5. [SRTM DEM — Digital Elevation Model](#5-srtm-dem--digital-elevation-model)
6. [INSAT-3DR — Meteorological Satellite Data](#6-insat-3dr--meteorological-satellite-data)
7. [Cross-Sensor Harmonization](#7-cross-sensor-harmonization)
8. [Processing Environment & Analytical Methods](#8-processing-environment--analytical-methods)
9. [Research Outputs & Results](#9-research-outputs--results)
10. [Data Sources & References](#10-data-sources--references)

---

## 1. Overview & Dataset Inventory

**SARC** combines multi-frequency SAR observations and terrain information to characterize backscatter variability, investigate historical environmental events, and analyze landscape changes in the Eastern Himalayas.

- **Study Region:** Teesta River Basin, Sikkim, India
- **Primary Reference Event:** South Lhonak Lake Glacial Lake Outburst Flood (GLOF) — **4 October 2023**
- **Primary Study AOI:** Singtam–Majitar–Rangpo downstream region
- **Research Approach:** Independent NISAR and Sentinel-1 processing branches with a common geographic study area.

### Dataset Inventory

| Dataset | Satellite / Provider | Product / Sensor Type | Primary Application | Status |
| :--- | :--- | :--- | :--- | :--- |
| **NISAR** | NASA–ISRO | S-band SAR (`GCOV`, `HH/HV`) | Multi-temporal backscatter analysis, feature engineering and anomaly detection | `Processed` |
| **Sentinel-1A** | ESA / Copernicus | C-band SAR (`GRD`, `VV/VH`) | Historical pre-event and post-event backscatter change analysis | `Processed` |
| **SRTM DEM** | NASA / USGS | SRTM 1 Arc-Second Global | Elevation-assisted terrain correction in SNAP | `Used` |
| **CartoDEM** | ISRO / NRSC | Digital Elevation Model | Potential terrain and hydrological analysis | `Not integrated` |
| **INSAT-3DR** | ISRO / MOSDAC | Imager / QPE products | Potential rainfall and atmospheric context | `Planned` |
| **OpenStreetMap** | OpenStreetMap contributors | River and geographic features | River-network context and proximity analysis | `Attempted; unavailable` |

**Dataset distinction:** SRTM was used during Sentinel-1 terrain correction. It must not be identified as CartoDEM. INSAT-3DR rainfall has not been processed as an input to the current SARC research outputs.

---

## 2. Study Area (AOI)

The study focuses on a compact downstream candidate region within the Teesta River Basin, covering the Singtam–Majitar–Rangpo area of Sikkim, India.

The same geographic AOI is used for the NISAR and Sentinel-1 research branches. Individual scene coverage and valid-pixel overlap are assessed independently.

### AOI Boundary

| Parameter | Value |
| :--- | :--- |
| **Region** | Singtam–Majitar–Rangpo, Teesta River Basin, Sikkim, India |
| **North Bound** | `27.2025° N` |
| **South Bound** | `27.1575° N` |
| **West Bound** | `88.4897° E` |
| **East Bound** | `88.5403° E` |
| **Geographic CRS** | `EPSG:4326` — WGS 84 |
| **Projected CRS** | `EPSG:32645` — WGS 84 / UTM Zone 45N |
| **Approximate AOI Size** | 5 km × 5 km |

### AOI Processing Context

- Geographic coordinates define the common study boundary.
- Projected coordinates are used for metric geospatial processing where applicable.
- NISAR and Sentinel-1 outputs are maintained in their respective processing grids.
- Individual raster dimensions are product- and processing-dependent; they are not assumed to be identical across sensors.
- No spatial mosaicking is used in the current study.

> **Event context:** The 4 October 2023 South Lhonak GLOF is the primary historical reference event. The selected AOI is downstream; inundation or damage within this AOI must not be assumed without independent evidence.

---

## 3. NISAR — S-band SAR

### Product Specifications

| Parameter | Details |
| :--- | :--- |
| **Mission** | NASA–ISRO Synthetic Aperture Radar (NISAR) |
| **Sensor Band** | S-band (`frequencyA`) |
| **Product Level** | Level-2 `GCOV` — Geocoded Covariance Product |
| **File Format** | `HDF5` (`.h5`) |
| **Polarizations** | `HH`, `HV` |
| **Orbit / Look Direction** | Ascending / Left-looking |
| **Track / Frame** | Track `170` / Frame `15` |
| **Processing CRS** | `EPSG:32645` |
| **Output Pixel Spacing** | `10 m` |

### Acquired Scene Inventory

| Acquisition Date | Track | Frame | Processing Status | Scene Identifier |
| :--- | :---: | :---: | :--- | :--- |
| **24 August 2026** | `170` | `15` | Processed for AOI | `NISAR_S2_PR_GCOV_028_170_A_015_3700_DHNA_A_20260824T233024_233101_P00500_M_F_I_001.h5` |
| **05 September 2026** | `170` | `15` | Processed for AOI | `NISAR_S2_PR_GCOV_029_170_A_015_3700_DHNA_A_20260905T233024_233100_P00500_M_F_I_001.h5` |
| **29 September 2026** | `170` | `15` | Processed for AOI | `NISAR_S2_PR_GCOV_031_170_A_015_3700_DHNA_A_20260929T233024_233101_P00500_M_F_I_001.h5` |

> **⚠️ Temporal Note:** These 2026 acquisitions represent later-condition observations. They do not capture the immediate pre-event or post-event state of the October 2023 GLOF.

### Internal HDF5 Structure

Primary HDF5 group path:

`/science/SSAR/GCOV/grids/frequencyA/`

| Dataset | Data Type | Description |
| :--- | :--- | :--- |
| `HHHH` | `float32` | HH–HH backscatter covariance |
| `HVHV` | `float32` | HV–HV backscatter covariance |
| `HHHV` | `complex64` | HH–HV cross-covariance |
| `mask` | `uint8` | Subswath validity mask |
| `inputDataExceptionMask` | `uint8` | Input exception flags |
| `numberOfLooks` | `float32` | Number of averaged looks |
| `rtcGammaToSigmaFactor` | `float32` | Radiometric terrain correction conversion factor |

### Processing Pipeline

- HDF5 product inspection and metadata review.
- AOI subset extraction.
- HH/HV covariance layer inspection.
- Valid-pixel and NoData assessment.
- Multi-temporal backscatter analysis.
- Feature engineering across acquisitions.
- KMeans exploratory clustering.
- Isolation Forest anomaly detection.
- Spatial coherence analysis.
- Anomaly inventory generation and visualization.

### NISAR Analytical Summary

| Metric | Result |
| :--- | :--- |
| **Acquisitions** | 3 |
| **Engineered Features** | 30 |
| **Exploratory KMeans Clusters** | 4 |
| **Anomaly Method** | Isolation Forest |
| **Spatial Analysis** | Spatial coherence and anomaly inventory |

**Interpretation:** KMeans groups are exploratory statistical clusters, not verified land-cover or flood classes. Isolation Forest outputs are statistical anomalies, not independently confirmed hazard observations.

GCOV is not an SLC product. No interferometric displacement or phase-based deformation claim is made.

---

## 4. Sentinel-1 — C-band SAR

### Actual Product Specifications

| Parameter | Details |
| :--- | :--- |
| **Mission / Platform** | Copernicus Sentinel-1A |
| **Sensor Band** | C-band |
| **Product Level** | Level-1 `GRD` |
| **Acquisition Mode** | `IW` — Interferometric Wide Swath |
| **Polarizations** | `VV`, `VH` |
| **Processing Software** | ESA SNAP |
| **Backscatter Representation** | Sigma0 |
| **Terrain Correction** | Range-Doppler terrain correction |
| **DEM Used** | SRTM 1 Arc-Second Global |
| **Output Format** | GeoTIFF |
| **Processing CRS** | `EPSG:32645` |

### Processed Scene Inventory

| Category | Acquisition Date | Platform | Polarization | Processing Status |
| :--- | :--- | :--- | :--- | :--- |
| **Pre-event** | `02 October 2023` | Sentinel-1A | VV/VH | `Processed` |
| **Post-event** | `14 October 2023` | Sentinel-1A | VV/VH | `Processed` |

**Pre-event product:**

`S1A_IW_GRDH_1SDV_20231002T120602_20231002T120627_050586_0617FC_8D3F.SAFE.zip`

**Post-event product:**

`S1A_IW_GRDH_1SDV_20231014T120602_20231014T120627_050761_061DFD_05BE.SAFE.zip`

### SNAP Processing Workflow

1. SAFE archive extraction.
2. Manifest and annotation inspection.
3. Acquisition metadata and AOI footprint verification.
4. Pre/post-event pair identification.
5. Orbit auxiliary handling.
6. Radiometric calibration to Sigma0.
7. Terrain correction using SRTM elevation data.
8. AOI-specific GeoTIFF export.
9. Pre/post backscatter comparison.
10. VV/VH change analysis.
11. 3 × 3 median-based speckle suppression.
12. MAD-based exploratory change thresholding.
13. VV/VH same-direction consensus analysis.
14. Connected-component candidate inventory generation.
15. Candidate geometry repair and GIS export.

### Generated Processing Outputs

- `S1A_IW_GRDH_..._Sigma0_TC_AOI.tif` — AOI-specific terrain-corrected Sigma0 outputs for both acquisitions.
- `SARC_S1_SpeckleFiltered_Change_dB.tif`
- `SARC_S1_VV_VH_Consensus_Change.tif`
- `SARC_S1_Consensus_Candidate_Inventory.gpkg`
- `SARC_S1_Consensus_Candidate_Inventory.geojson`
- `SARC_S1_Consensus_Candidate_Inventory.csv`
- `SARC_S1_SpeckleAware_Change_Map.png`
- `SARC_S1_Change_Component_Inventory.csv`
- `SARC_S1_Robust_Change_Statistics.csv`
- `SARC_S1_VV_VH_Consensus_Components.csv`
- `SARC_S1_VV_VH_Agreement_Statistics.csv`

### Sentinel-1 Analytical Summary

| Metric | Result |
| :--- | :--- |
| **Scenes Processed** | `2` |
| **AOI-intersecting Scenes** | `2` |
| **Compatible Pre/Post Pair** | `1` |
| **Consensus Candidate Regions** | `37` |
| **Total Candidate Area** | `9.42 ha` |
| **River Proximity Analysis** | Not performed |

> **Scientific Interpretation:** The 37 consensus regions are exploratory radar backscatter change candidates. The 9.42 ha value is their mapped candidate area, not a confirmed flood-affected area. VV/VH agreement is not independent validation.

### River Network Analysis

OpenStreetMap Overpass was queried for contextual river-network analysis. Requests returned HTTP `406` and `429` responses. Consequently, the river proximity inventory and distance measurements were not generated.

No nearest-river distance or river-causality claim is reported.

---

## 5. SRTM DEM — Digital Elevation Model

### Actual DEM Used

| Parameter | Details |
| :--- | :--- |
| **Dataset** | SRTM 1 Arc-Second Global |
| **Source** | NASA / USGS |
| **Tile** | `N27E088` |
| **Tile Archive** | `N27E088.SRTMGL1.hgt.zip` |
| **Native Format** | HGT |
| **Application** | SNAP terrain correction |
| **Processing Branch** | Sentinel-1 |

The SRTM elevation tile was automatically retrieved by SNAP during Sentinel-1 Range-Doppler terrain correction.

### Processing Role

- Elevation-assisted geocoding.
- Terrain correction of Sentinel-1 Sigma0 backscatter.
- Reduction of terrain-related geometric distortions within the supported correction workflow.

**Dataset governance:** The DEM used in the completed Sentinel-1 processing is SRTM, not CartoDEM.

### Potential Future Terrain Analysis

- Elevation distribution.
- Slope and aspect.
- Flow direction and accumulation.
- Drainage network characterization.
- River corridor and settlement exposure context.

These derivatives require their own processing and validation before being included as completed analytical outputs.

---

## 6. INSAT-3DR — Meteorological Satellite Data

### Planned Specifications

| Parameter | Details |
| :--- | :--- |
| **Mission / Provider** | INSAT-3DR — ISRO |
| **Institutional Data Portal** | MOSDAC |
| **Instrument** | Imager and Sounder |
| **Potential Product** | Quantitative Precipitation Estimation (QPE) |
| **Potential Variable** | Rainfall rate / accumulated precipitation |
| **Reference Period** | `01–07 October 2023` |
| **Integration Status** | Planned |

### Potential Research Application

Rainfall observations may provide important meteorological context for interpreting SAR backscatter changes and investigating hydrological conditions around the October 2023 event.

Before ingestion, verify:

- Exact product and dataset identifier.
- Rainfall variable and physical units.
- Spatial coverage and native grid resolution.
- Temporal resolution and observation interval.
- Scale and offset factors.
- Quality flags and missing-value conventions.
- Product format and embedded metadata.

**Important:** INSAT-3DR rainfall is documented as a potential supporting dataset. No INSAT-3DR rainfall raster, rainfall-conditioned SAR analysis, or rainfall-derived result is included in the current completed NISAR and Sentinel-1 outputs.

---

## 7. Cross-Sensor Harmonization

SARC maintains independent NISAR and Sentinel-1 processing branches.

The two SAR systems are not directly interchangeable.

| Sensor / Dataset | Measurement | Key Considerations |
| :--- | :--- | :--- |
| **NISAR** | S-band SAR covariance | `HH/HV`, GCOV matrix semantics, left-looking geometry |
| **Sentinel-1** | C-band SAR backscatter | `VV/VH`, GRD intensity processing, acquisition geometry |
| **SRTM DEM** | Elevation | Terrain correction and vertical reference considerations |
| **INSAT-3DR** | Meteorological observations | Product-specific units, spatial grid and temporal aggregation |

### Harmonization Requirements

- Frequency and wavelength differences.
- Polarization differences.
- Incidence-angle and viewing geometry.
- Radiometric calibration and normalization.
- Spatial resolution and pixel spacing.
- Acquisition date and temporal separation.
- Product representation and processing level.

The current Sentinel-1 acquisitions are from October 2023, whereas NISAR acquisitions are from August–September 2026.

**No temporally matched cross-sensor comparison or direct C-band/S-band validation has been performed.**

---

## 8. Processing Environment & Analytical Methods

### Research Environment

| Component | Technology |
| :--- | :--- |
| **Satellite Processing** | ESA SNAP |
| **Computational Environment** | Google Colab |
| **Programming Language** | Python |
| **Raster Processing** | Rasterio, GDAL |
| **Vector Processing** | GeoPandas, Shapely |
| **Numerical Analysis** | NumPy, SciPy |
| **Machine Learning** | Scikit-learn |
| **Visualization** | Matplotlib |

### Analytical Methods

**NISAR**
- Multi-temporal backscatter statistics.
- Feature engineering.
- KMeans exploratory clustering.
- Isolation Forest anomaly detection.
- Spatial coherence analysis.

**Sentinel-1**
- Sigma0 backscatter comparison.
- VV/VH change indicators.
- Median-based speckle suppression.
- MAD-based exploratory thresholding.
- Same-direction VV/VH consensus.
- Connected-component analysis.
- Candidate polygon generation and geometry repair.

---

## 9. Research Outputs & Results

### Sentinel-1 Final Research Package

**Package:** `SARC_Sentinel1_Final_Research_Package.zip`

**Report:** `SARC_Sentinel1_Final_Research_Report.json`

**README:** `README_SARC_Sentinel1.md`

| Metric | Final Value |
| :--- | :--- |
| Scenes | `2` |
| Consensus Candidates | `37` |
| Candidate Area | `9.42 ha` |
| Files in ZIP Package | `26` |
| ZIP Package Size | `29.62 MB` |
| River Analysis | Not performed |

### Google Drive Backup

**Drive location:** `MyDrive/SARC/Sentinel1`

| Backup Component | Status |
| :--- | :--- |
| Generated outputs | Saved |
| Processed rasters | Saved |
| Metadata | Saved |
| Final research ZIP | Saved |
| Total files in backup | `27` |
| Total backup size | `105.16 MB` |

The Drive backup contains generated research outputs and associated processing data. It does not imply that the original raw SAFE archives were backed up.

### NISAR Research Outputs

The NISAR research branch includes:

- Three processed S-band GCOV acquisitions.
- Multi-temporal analysis outputs.
- 30 engineered features.
- Four exploratory clusters.
- Statistical anomaly inventory.
- Spatial coherence analysis.
- Research visualizations and associated outputs.

The NISAR results describe statistical and spatial observations in the analyzed datasets. They do not independently establish flood occurrence, damage, or landslide activity.

### Scientific Limitations

1. Sentinel-1 analysis uses two acquisitions separated by 12 days.
2. Backscatter changes can be influenced by soil moisture, vegetation, rainfall, land-use activity, speckle, incidence angle and residual geometric effects.
3. MAD thresholds are exploratory, not validated flood-detection thresholds.
4. VV/VH agreement is not independent validation.
5. Consensus candidate area is not confirmed inundation area.
6. River proximity analysis was not completed.
7. No independent ground-truth flood-extent validation has been completed.
8. NISAR 2026 observations cannot reconstruct the immediate 2023 event.
9. No temporally matched cross-sensor validation has been performed.

---

## 10. Data Sources & References

### NISAR — NASA / ISRO

1. **ISRO — NISAR S-Band SAR Data Products Release:** https://www.isro.gov.in/NISARS_Band_SAR_Data_Products_Release.html
2. **ISRO / NRSC — Bhoonidhi Earth Observation Data Hub:** https://bhoonidhi.nrsc.gov.in/
3. **Bhoonidhi — NISAR Mission and Data Products:** https://bhoonidhi.nrsc.gov.in/NISAR/
4. **NISAR Product Release Information:** https://bhoonidhi.nrsc.gov.in/NISAR/NisarProducts.html
5. **NISAR Data Product Format Documentation:** https://bhoonidhi.nrsc.gov.in/NISAR/NISAR_Data_Product_Format_Document_V1.2.1_digisigned.pdf
6. **NASA — NISAR Mission Overview:** https://science.nasa.gov/mission/nisar/

### Sentinel-1 — ESA / Copernicus

1. **Copernicus Data Space Ecosystem — Sentinel-1:** https://dataspace.copernicus.eu/data-collections/copernicus-sentinel-missions/sentinel-1
2. **Copernicus Data Space — Sentinel-1 Technical Documentation:** https://documentation.dataspace.copernicus.eu/Data/Sentinel1.html
3. **Copernicus Sentinel Online:** https://sentinels.copernicus.eu/
4. **ISRO — Bhoonidhi Data Hub:** https://bhoonidhi.nrsc.gov.in/

### SRTM DEM — NASA / USGS

1. **NASA Earthdata — SRTM:** https://www.earthdata.nasa.gov/data/instruments/srtm
2. **USGS — EarthExplorer:** https://earthexplorer.usgs.gov/

### CartoDEM — ISRO / NRSC

1. **NRSC — CartoDEM Product Information:** https://www.nrsc.gov.in/
2. **ISRO / NRSC — Bhoonidhi Data Hub:** https://bhoonidhi.nrsc.gov.in/

### INSAT-3DR — ISRO / MOSDAC

1. **MOSDAC — INSAT-3DR Mission Overview:** https://www.mosdac.gov.in/insat-3dr-introduction
2. **MOSDAC — INSAT-3DR Data Products:** https://www.mosdac.gov.in/insat-3dr-data-products
3. **MOSDAC — Data Portal:** https://mosdac.gov.in/
4. **ISRO — MOSDAC Institutional Overview:** https://www.isro.gov.in/ISRO_EN/MOSDAC.html

### Geospatial & Scientific Processing Libraries

- **ESA SNAP:** https://step.esa.int/main/download/snap-download/
- **GDAL:** https://gdal.org/
- **Rasterio:** https://rasterio.readthedocs.io/
- **GeoPandas:** https://geopandas.org/
- **NumPy:** https://numpy.org/doc/
- **SciPy:** https://docs.scipy.org/doc/scipy/
- **Pandas:** https://pandas.pydata.org/docs/
- **Scikit-learn:** https://scikit-learn.org/stable/

---

**SARC — Satellite Analysis and Radar-based Characterization**

*Research-driven geospatial intelligence for environmental monitoring, river-corridor analysis, and community-oriented information delivery.*
