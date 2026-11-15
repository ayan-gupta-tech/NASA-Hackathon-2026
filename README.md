 <p align="center">
  <img src="./assets/SARC_Logo.jpeg" alt="SARC Logo" width="850">
</p>

# SARC — Multi-Sensor SAR & Geospatial Intelligence Platform

**By IoT Avengers** 
[NASA International Space Apps Challenge Global Nominee 2025](https://www.spaceappschallenge.org/2025/find-a-team/iot-avengers/)
[NASA International Space Apps Challenge 2026](https://www.spaceappschallenge.org/)  
**Event:** 14–15 November 2026

[![Status](https://img.shields.io/badge/Status-Active_Development-blue.svg)](#)
[![Study Region](https://img.shields.io/badge/Region-Teesta_River_Basin%2C_Sikkim-green.svg)](#3-study-area--area-of-interest)
[![Remote Sensing](https://img.shields.io/badge/Domain-SAR_%7C_Geospatial_Intelligence-purple.svg)](#)
[![Challenge](https://img.shields.io/badge/NASA-Space_Apps_2026-orange.svg)](#)

---

## 1. Project Overview

**SARC — Multi-Sensor SAR & Geospatial Intelligence Platform** is a research-driven Earth Observation and geospatial analysis framework designed to investigate satellite-observed environmental changes across vulnerable river corridors.

The project focuses on the Teesta River Basin in Sikkim, India, with particular attention to the downstream Singtam–Majitar–Rangpo region following the catastrophic South Lhonak Glacial Lake Outburst Flood (GLOF) of 4 October 2023.

SARC explores how multi-temporal Synthetic Aperture Radar (SAR), terrain information, rainfall observations and geospatial datasets can support environmental change analysis and disaster-related situational awareness.

The framework currently investigates two independent SAR processing branches:

- **Sentinel-1A C-band:** Multi-temporal VV/VH backscatter change analysis.
- **NISAR S-band:** Multi-temporal HH/HV covariance-based characterization and exploratory anomaly analysis.

Additional terrain and meteorological datasets are planned for the next development phase.

SARC also includes a Flutter-based mobile application that acts as the user-facing interface of the platform, bringing the project's geospatial research and visualization capabilities closer to end users.

The long-term vision is to organize these observations into a human-reviewed geospatial intelligence workflow that can support researchers, disaster-management stakeholders and communities.

**SARC is currently a research and analysis prototype. Its outputs are exploratory and are not validated flood predictions, operational warnings or confirmed flood extents.**

## 2. Problem Statement & Research Motivation

Mountainous river basins are exposed to sudden hydrological and geomorphological changes caused by intense rainfall, glacial lake outbursts and other environmental events.

The 4 October 2023 South Lhonak GLOF demonstrated the destructive potential of sudden water surges across the Teesta River system.

Communities, roads, bridges, settlements and other infrastructure located along downstream river corridors can be exposed to rapidly changing conditions.

Conventional optical satellite observations may be limited by cloud cover, while rugged Himalayan terrain makes continuous ground-based observation challenging.

SARC investigates the following research questions:

1. Can multi-temporal SAR observations help identify spatial patterns of surface-backscatter change around a disaster-affected river corridor?
2. How can different SAR missions contribute complementary observations across spatial and temporal dimensions?
3. How can terrain, rainfall and other geospatial datasets provide additional environmental context?
4. How can exploratory satellite-derived observations be organized into interpretable, human-reviewed geospatial information?

The objective is to develop a reproducible research workflow for satellite-based environmental change characterization, rather than claim confirmed flood detection or forecasting.

## 3. Study Area & Area of Interest

**Primary Study Region:** Teesta River Basin, Sikkim, India.

**Focused AOI:** Downstream Teesta corridor around Singtam–Majitar–Rangpo.

The selected AOI covers approximately 5 × 5 km and is used as a common candidate study region for the Sentinel-1 and NISAR analysis branches. Actual scene coverage and valid-pixel availability are assessed independently for each acquisition.

### AOI Coordinates

| Parameter | Coordinate |
|---|---:|
| North | 27.2025° N |
| South | 27.1575° N |
| West | 88.4897° E |
| East | 88.5403° E |
| Min X | 88.4897 |
| Min Y | 27.1575 |
| Max X | 88.5403 |
| Max Y | 27.2025 |
| Geographic CRS | EPSG:4326 |
| Processing CRS | EPSG:32645 — WGS 84 / UTM Zone 45N |

The AOI is used for focused satellite-data extraction and comparison. It does not represent the complete geographical extent of the 2023 flood.

## 4. Dataset Inventory & Sources

SARC uses a multi-source Earth Observation approach. Datasets are separated by sensor, acquisition period and processing status to avoid mixing completed analysis with planned inputs.

### 4.1 Sentinel-1A — C-band SAR

| Parameter | Details |
|---|---|
| Mission | Sentinel-1A |
| Sensor | C-band SAR |
| Product | GRD — IW |
| Polarizations | VV, VH |
| Acquisitions | 02 October 2023, 14 October 2023 |
| Data Source | ISRO Bhoonidhi |
| Processing | ESA SNAP |
| Role | Multi-temporal backscatter change analysis |

The two acquisitions provide a 12-day-separated observation pair around the 4 October 2023 South Lhonak GLOF event.

### 4.2 NISAR — S-band SAR

| Parameter | Details |
|---|---|
| Mission | NASA-ISRO NISAR |
| Frequency | S-band |
| Product | GCOV |
| Product Family | NISAR_SSAR_W_GCOV_DH |
| Polarizations | HH, HV |
| Format | HDF5 |
| Pixel Spacing | 10 m |
| Track | 170 |
| Frame | 15 |
| Acquisition Dates | 24 August, 05 September, 29 September 2026 |
| Role | Temporal characterization and exploratory anomaly analysis |

**Selected acquisitions:**

- `NISAR_S2_PR_GCOV_028_170_A_015_3700_DHNA_A_20260824T233024_233101_P00500_M_F_I_001.h5`
- `NISAR_S2_PR_GCOV_029_170_A_015_3700_DHNA_A_20260905T233024_233100_P00500_M_F_I_001.h5`
- `NISAR_S2_PR_GCOV_031_170_A_015_3700_DHNA_A_20260929T233024_233101_P00500_M_F_I_001.h5`

**HDF5 group:**

`/science/SSAR/GCOV/grids/frequencyA/`

Selected datasets include:

- `HHHH` — HH–HH covariance
- `HVHV` — HV–HV covariance
- `HHHV` — HH–HV cross-covariance
- `mask` — Subswath validity mask
- `inputDataExceptionMask` — Input-data exception mask
- `numberOfLooks` — Number of looks
- `rtcGammaToSigmaFactor` — RTC Gamma-to-Sigma factor

NISAR observations from 2026 are treated as a separate later observation series. They are not used to reconstruct or directly validate the October 2023 GLOF.

### 4.3 SRTM DEM — Terrain Correction

| Parameter | Details |
|---|---|
| Dataset | SRTM 1 Arc-Second Global |
| Tile | N27E088 |
| Resolution | Approximately 30 m |
| Usage | Sentinel-1 terrain correction |
| Source | SNAP DEM retrieval |

SRTM DEM was used during Sentinel-1 terrain correction. It is not a substitute for the planned CartoDEM terrain-analysis workflow.

### 4.4 CartoDEM — Planned Terrain Dataset

CartoDEM is planned for the next phase to support terrain characterization, including:

- Elevation and elevation variation.
- Slope and aspect derivation.
- Drainage and terrain-context analysis.
- Geospatial relationship analysis with river corridors.

**Acquisition status:** CartoDEM could not be obtained during the current development window because the Bhoonidhi server was unavailable. It has therefore not been included in the completed processing outputs.

### 4.5 ALOS-2 PALSAR-2 — Planned L-band SAR

ALOS-2 PALSAR-2 is planned as an additional L-band SAR data source.

Potential research applications include:

- Complementary L-band backscatter observations.
- Cross-frequency SAR characterization.
- Multi-sensor temporal comparison.
- Investigation of differences between C-band, S-band and L-band observations.

**Status:** Planned for the next phase; no ALOS-2 acquisition or processing results are claimed in the current implementation.

### 4.6 INSAT-3DR — Planned Meteorological Dataset

INSAT-3DR observations are planned to introduce meteorological context into the research framework.

Potential applications include:

- Rainfall-related observation inputs.
- Temporal comparison with SAR acquisitions.
- Environmental context for surface-change interpretation.
- Future integration with other rainfall datasets.

**Status:** Planned for the next phase; no completed INSAT-3DR rainfall analysis is claimed in the current results.

### 4.7 Additional Potential Data Sources

| Dataset / Source | Potential Application | Status |
|---|---|---|
| GPM IMERG | Satellite precipitation observations | Planned |
| ERA5-Land | Meteorological and land-surface context | Planned |
| IMD Rainfall | Rainfall observations | Planned |
| NASA POWER | Meteorological variables | Potential supporting source |
| OpenStreetMap | River, road and settlement context | Attempted; river proximity analysis incomplete |

## 5. Development Environment & Technology Stack

### Development Environment

- Google Colab
- Python
- ESA SNAP
- Jupyter Notebooks
- Git and GitHub

### Geospatial & Scientific Libraries

- Rasterio
- GDAL
- NumPy
- GeoPandas
- Shapely
- Matplotlib

### Machine Learning & Analysis

- Scikit-learn
- KMeans Clustering
- Isolation Forest
- Median filtering
- Median Absolute Deviation (MAD)

### Supporting Tools

- HDF5 / h5py
- QGIS for geospatial inspection
- ESA SNAP for Sentinel-1 processing

The libraries and tools are used according to the requirements of individual processing stages.

## 6. Sentinel-1A C-band Processing Workflow

The Sentinel-1 branch investigates multi-temporal C-band backscatter changes across the selected AOI.

### 6.1 Input Data

Two Sentinel-1A GRD IW acquisitions were selected:

- 02 October 2023
- 14 October 2023

Both acquisitions contain VV and VH polarization and intersect the selected AOI.

### 6.2 Pre-processing

The downloaded SAFE products were extracted and inspected. Product manifests and annotation XML files were examined to verify acquisition metadata and geographic coverage.

The processing workflow in ESA SNAP included:

1. Orbit file application.
2. Radiometric calibration to Sigma0.
3. Terrain correction using SRTM DEM.
4. AOI-specific output preparation.
5. VV and VH band extraction.

### 6.3 Change Analysis

The processed observations were used for exploratory temporal backscatter analysis.

The workflow includes:

1. Multi-temporal image comparison.
2. 3 × 3 median filtering for speckle-aware analysis.
3. Difference-based change characterization.
4. MAD-based exploratory thresholding.
5. Connected-component extraction.
6. VV/VH same-direction agreement analysis.
7. Candidate polygon generation.
8. Geometry validation and repair.

### 6.4 Generated Outputs

The Sentinel-1 branch produces raster, tabular and vector outputs, including:

- Speckle-filtered backscatter change raster.
- Robust change statistics.
- Connected-component inventory.
- VV/VH consensus raster.
- Consensus agreement statistics.
- Candidate polygon inventory in GeoPackage and GeoJSON formats.
- Exploratory change maps.

## 7. NISAR S-band Processing Workflow

The NISAR branch investigates multi-temporal S-band covariance observations using the selected GCOV HDF5 acquisitions.

### 7.1 Data Extraction

The selected HDF5 products are accessed through:

`/science/SSAR/GCOV/grids/frequencyA/`

The HH, HV and supporting covariance-related datasets are extracted for further processing.

### 7.2 AOI Processing

The workflow includes:

1. HDF5 metadata inspection.
2. HH/HV dataset extraction.
3. Validity-mask inspection.
4. AOI subset extraction.
5. Spatial alignment and temporal comparison.

### 7.3 Feature Engineering

Temporal and statistical characteristics are organized into an exploratory feature set.

A total of **30 engineered features** are used in the current analysis.

### 7.4 Exploratory Analysis

The workflow includes:

- Temporal statistics.
- KMeans clustering with four exploratory clusters.
- Isolation Forest anomaly identification.
- Spatial coherence inspection.
- Anomaly inventory generation.
- Multi-panel research visualization.

The KMeans clusters are exploratory groupings and are not confirmed land-cover or flood classes. Isolation Forest outputs represent statistical outliers rather than confirmed environmental hazards.

## 8. Analytical Methods

SARC combines conventional remote-sensing processing with exploratory statistical and machine-learning methods.

| Method | Application |
|---|---|
| Radiometric Calibration | Sentinel-1 backscatter preparation |
| Terrain Correction | Geometric correction using DEM |
| Median Filtering | Speckle-aware image analysis |
| Temporal Differencing | Multi-temporal backscatter comparison |
| MAD | Robust exploratory change thresholding |
| Connected Components | Spatial grouping of candidate pixels |
| VV/VH Consensus | Same-direction polarization agreement |
| Polygonization | Conversion of candidate raster regions into vector geometries |
| Feature Engineering | NISAR temporal and statistical feature preparation |
| KMeans | Exploratory clustering |
| Isolation Forest | Statistical anomaly identification |

These methods support research-oriented characterization. Their outputs require further interpretation and independent validation before any operational use.

## 9. Preliminary Results & Generated Outputs

### 9.1 Sentinel-1A Results

| Metric | Result |
|---|---:|
| Acquisitions | 2 |
| AOI-intersecting scenes | 2 |
| Temporal comparison pair | 1 |
| Polarizations | VV, VH |
| Valid consensus candidate geometries | 37 |
| Candidate polygon area | Approximately 9.42 ha |
| Geometry validity after repair | All 37 valid |

The 9.42 ha figure represents the combined area of extracted candidate polygons. It must not be interpreted as confirmed flooded area.

River-proximity analysis was not completed because OpenStreetMap Overpass requests encountered HTTP 406 and HTTP 429 errors.

### 9.2 NISAR Results

| Metric | Result |
|---|---:|
| Acquisitions | 3 |
| Polarizations | HH, HV |
| Engineered features | 30 |
| KMeans clusters | 4 |
| Anomaly method | Isolation Forest |
| Contamination parameter | 2% |

The contamination parameter is an analyst-selected exploratory setting, not a validated hazard threshold.

### 9.3 Output Interpretation

The current outputs demonstrate the execution of two separate SAR analysis workflows:

- Sentinel-1A provides an exploratory C-band temporal backscatter-change inventory.
- NISAR provides an exploratory S-band temporal characterization and anomaly-analysis workflow.

The results are not presented as confirmed flood extents, validated flood detection, or ground-truth-verified hazard maps.

## 10. Scientific Interpretation & Limitations

The current analysis is exploratory and has several important limitations.

1. **Limited temporal sampling:** Sentinel-1 analysis uses two acquisitions separated by 12 days.
2. **No ground-truth validation:** Candidate regions have not been independently verified through field observations or authoritative reference flood boundaries.
3. **Backscatter ambiguity:** Changes may be associated with soil moisture, vegetation, rainfall, agricultural activity, surface roughness, speckle or other environmental factors.
4. **Geometric uncertainty:** Residual misregistration and terrain-related effects may influence pixel-level comparisons.
5. **No confirmed flood classification:** Candidate polygons are not equivalent to mapped flood extents.
6. **No operational threshold:** Exploratory MAD and machine-learning parameters are not validated warning thresholds.
7. **NISAR temporal limitation:** The 2026 acquisitions cannot directly reconstruct the October 2023 event.
8. **Incomplete supporting layers:** River-proximity analysis and additional terrain/rainfall integration remain future work.

These limitations are retained to ensure that the research outputs are interpreted responsibly.

## 11. Cross-Sensor Research Strategy

SARC is designed to explore complementary Earth Observation data sources.

| Sensor / Dataset | Frequency / Type | Research Role |
|---|---|---|
| Sentinel-1A | C-band SAR | Multi-temporal VV/VH backscatter analysis |
| NISAR | S-band SAR | HH/HV covariance-based characterization |
| ALOS-2 PALSAR-2 | L-band SAR | Planned complementary SAR observations |
| SRTM DEM | Elevation | Terrain correction |
| CartoDEM | Elevation | Planned terrain characterization |
| INSAT-3DR | Meteorological | Planned rainfall-related context |

The current Sentinel-1 and NISAR processing workflows are maintained as separate branches.

A complete cross-sensor fusion workflow has not yet been implemented. Differences in acquisition dates, frequency, resolution, geometry and product structure must be considered before combining observations.

## 12. Proposed Platform Architecture

The long-term SARC architecture is organized around five functional layers:

1. **Data Acquisition Layer:** Satellite SAR, terrain, rainfall and supporting geospatial sources.
2. **Pre-processing Layer:** Product extraction, calibration, terrain correction, AOI alignment and data-quality checks.
3. **Analysis Layer:** Temporal comparison, feature engineering, anomaly characterization and geospatial analysis.
4. **Geospatial Intelligence Layer:** Spatial inventories, contextual layers, map generation and research interpretation.
5. **Application Layer:** Flutter-based mobile application for user-facing interaction and geospatial information access.
6. **Human Review & Communication Layer:** Researcher review, visualization and community-facing information.

The architecture is a proposed development direction. Not all layers are currently implemented as an integrated deployed system.

## 13. System Architecture

```text
                    SARC — SYSTEM ARCHITECTURE
                              |
                              v
                 MULTI-SOURCE DATA ACQUISITION
                              |
          +-------------------+-------------------+
          |                   |                   |
          v                   v                   v
      SENTINEL-1A            NISAR           PLANNED DATA
       C-BAND                S-BAND          CartoDEM
      VV / VH                HH / HV         ALOS-2 PALSAR-2
          |                   |              INSAT-3DR
          v                   v                   |
     SAFE / GRD            GCOV / HDF5             |
          |                   |                   |
          v                   v                   |
     ESA SNAP             HDF5 EXTRACTION          |
 Orbit / Calibration      AOI / Feature Prep       |
 Terrain Correction       Temporal Analysis       |
          |                   |                   |
          v                   v                   |
     BACKSCATTER          CLUSTERING /             |
     CHANGE ANALYSIS      ANOMALY ANALYSIS         |
          |                   |                   |
          +-------------------+-------------------+
                              |
                              v
                   GEOSPATIAL OUTPUT LAYER
                              |
                +-------------+-------------+
                |             |             |
                v             v             v
             RASTERS        VECTORS      STATISTICS
                |             |             |
                +-------------+-------------+
                              |
                              v
                 GEOSPATIAL INTELLIGENCE
                  & RESEARCH INTERPRETATION
                              |
                              v
                   DATA / APPLICATION LAYER
                              |
                              v
                    FLUTTER MOBILE APP
                              |
                              v
                    USER-FACING INTERFACE
                              |
                              v
                    HUMAN REVIEW & FEEDBACK
                              |
                              v
                   COMMUNITY INFORMATION
```

The diagram represents the intended research architecture. Sentinel-1 and NISAR outputs are currently generated through separate processing workflows.

## 14. Repository Structure

```text
SARC/
│
├── assets/
│   └── SARC_Logo.jpeg
│
├── notebooks/
│   ├── SARC_Sentinel1_Event_Analysis_Majitar-Rangpo.ipynb
│   ├── NISAR_GCOV_Analysis.ipynb
│   └── INSAT-3DR+cartoDEM.ipynb
│
├── outputs/
│   ├── Sentinel1/
│   │   ├── backscatter_change/
│   │   ├── consensus/
│   │   ├── candidate_inventory/
│   │   └── research_maps/
│   │
│   └── NISAR/
│       ├── temporal_analysis/
│       ├── feature_engineering/
│       ├── clustering/
│       └── anomaly_analysis/
│
├── figures/
│   ├── architecture.png
│   ├── methodology.png
│   └── research_results.png
│
├── requirements.txt
└── README.md
```

The repository structure represents the organization of project documentation, notebooks and selected research outputs. Only files actually committed to the repository should be treated as available project assets.

## 15. Installation, Setup & Data Management

### 15.1 Environment Setup

The primary development environment is Google Colab, with ESA SNAP used for Sentinel-1 processing.

Install the commonly used Python dependencies:

```bash
pip install numpy rasterio geopandas shapely matplotlib scikit-learn h5py
```

GDAL and other system-level dependencies may require environment-specific installation.

### 15.2 Running the Notebooks

1. Open the relevant notebook in Google Colab.
2. Configure the input dataset paths.
3. Ensure that the required satellite products are available.
4. Run the processing cells in sequence.
5. Inspect the generated raster, vector and statistical outputs.
6. Save selected research outputs and figures.

The Sentinel-1 processing workflow requires ESA SNAP and the relevant extracted SAFE products.

The NISAR workflow requires the corresponding GCOV HDF5 acquisitions.

### 15.3 Data Management

- Large raw satellite products may be stored separately from the public source repository.
- Generated outputs should retain acquisition dates and processing metadata.
- Intermediate and final research products should be clearly distinguished.
- Credentials, access tokens and private account information must not be committed.
- Third-party datasets and software must retain their respective attribution and usage conditions.

## 16. Future Work & Next Development Phase

The next phase will expand SARC from separate SAR analysis branches toward a more comprehensive multi-source geospatial research framework.

### 16.1 Planned Dataset Integration

- **CartoDEM:** Detailed terrain characterization, elevation, slope and drainage analysis. Acquisition was blocked during the current development window due to Bhoonidhi server unavailability.
- **ALOS-2 PALSAR-2:** Additional L-band SAR observations for complementary multi-frequency analysis.
- **INSAT-3DR:** Meteorological and rainfall-related observations for environmental context.
- **GPM IMERG / ERA5-Land / IMD:** Potential supporting precipitation and meteorological datasets.

### 16.2 Planned Analytical Development

- Terrain-guided geospatial characterization.
- Multi-frequency SAR comparison.
- Rainfall and SAR temporal-context analysis.
- Improved spatial-context integration.
- River and settlement proximity analysis.
- Independent validation using authoritative reference datasets.
- Improved uncertainty and quality assessment.

### 16.3 Platform Development

- Flutter mobile application refinement and feature expansion.
- Integration of geospatial research outputs into the mobile interface.
- Interactive map visualization and layer management.
- Backend/API integration and automated data delivery, where not yet implemented.
- Human-reviewed interpretation workflow.
- Community-facing geospatial information.

These are planned developments and are not represented as completed features of the current prototype.

## 17. NASA Space Apps Challenge 2026 — AI Usage Disclosure & Project Definition

### Project Definition

**SARC — Multi-Sensor SAR & Geospatial Intelligence Platform** investigates satellite-derived environmental changes in the Teesta River Basin using multi-temporal SAR and geospatial analysis.

The project combines Sentinel-1A C-band and NISAR S-band research workflows, with planned integration of terrain, meteorological and additional SAR datasets.

Its purpose is to develop a scientifically responsible framework for environmental change characterization and geospatial situational awareness.

### AI Usage Disclosure

AI assistance was used as a supporting development tool during the project.

**AI-assisted activities included:**

- Research ideation and technical discussion.
- Assistance with Python code development and debugging.
- Guidance on satellite-product interpretation and processing workflows.
- Assistance with documentation, README organization and presentation content.

**Human team contributions included:**

- Selecting the study region and defining the AOI.
- Identifying and selecting relevant satellite datasets.
- Downloading and inspecting the available satellite products.
- Configuring and executing processing workflows in Google Colab and ESA SNAP.
- Performing geospatial analysis and inspecting generated outputs.
- Interpreting the results and defining research limitations.
- Making technical decisions regarding the project workflow and future development.

AI assistance is disclosed as a development aid. AI tools are not project team members, human contributors or commit authors. Generated outputs are not represented as independently validated scientific findings.

### Development Timeline

The project was developed during the NASA Space Apps Challenge 2026 event window:

- **14 November 2026:** Project development and research workflow implementation began.
- **15 November 2026:** Continued processing, analysis, documentation and project refinement.

The public repository and its commit history should reflect the actual development contributions of the human team members during the event.

### Final Research Position

SARC is an evolving multi-sensor SAR and geospatial research framework. Its current outputs provide preliminary evidence of the feasibility of separate Sentinel-1 and NISAR analysis workflows.

Further terrain integration, additional SAR observations, rainfall-context analysis, ground-truth validation and platform development are required before the framework can support operational disaster-management decisions.

**Built by IoT Avengers — NASA Space Apps Challenge 2026.**
