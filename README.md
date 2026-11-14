# SARC — Multi-Sensor SAR & Geospatial Intelligence Platform

**By IoT Avengers**  
[NASA International Space Apps Challenge — Global Nominee 2025](https://www.spaceappschallenge.org/2025/find-a-team/iot-avengers/)

## 1. Project Overview

SARC is a research-driven, multi-sensor Synthetic Aperture Radar (SAR) and geospatial intelligence platform designed to investigate satellite-observed environmental changes, analyze river-corridor conditions, examine potentially exposed areas, and communicate geospatial information through monitoring and community-facing applications.

The platform combines:
- Satellite Earth Observation data
- SAR and geospatial processing
- Terrain and environmental context
- Spatial analysis and change detection
- Centralized backend and data management
- Web-based monitoring dashboard
- Community-facing mobile application
- Human-reviewed information delivery

**Core objective:** Bridge the gap between satellite-derived intelligence, monitoring teams, and communities through scientifically responsible and understandable geospatial information.

## 2. Primary Research Study

**Research event:** 4 October 2023 — South Lhonak Lake Glacial Lake Outburst Flood (GLOF)  
**Study region:** Teesta River Basin, Sikkim, India  
**Primary investigation area:** Downstream Singtam–Majitar–Rangpo region.

Research questions:
1. Can Sentinel-1 observations reveal meaningful surface backscatter changes around the 2023 event?
2. What differences are observable between pre-event and post-event acquisitions?
3. How can river corridors, terrain, and nearby settlements be represented spatially?
4. What additional information can later NISAR S-band observations provide?
5. How can satellite-derived indicators be communicated responsibly?

The downstream study area must not automatically be considered inundated or damaged. Event impact requires independent evidence.

## 3. Area of Interest (AOI)

**Study area:** Singtam–Majitar–Rangpo downstream region, Teesta River Basin, Sikkim, India.

**Coordinate system:** WGS 84 — EPSG:4326

| Boundary | Coordinate |
|---|---:|
| North | 27.2025° N |
| South | 27.1575° N |
| West | 88.4897° E |
| East | 88.5403° E |

The compact bounding box is approximately 5 km × 5 km.

The same candidate AOI is used for the NISAR and Sentinel-1 research branches. Actual scene coverage and river/settlement inclusion should be assessed using the respective acquisition footprints and geospatial layers.

**Projected processing CRS:** EPSG:32645 where applicable to the processing grid.

No spatial mosaicking is used in the current study workflow.

## 4. Satellite and Geospatial Datasets

### 4.1 Sentinel-1A — C-band SAR

| Parameter | Details |
|---|---|
| Satellite | Sentinel-1A |
| Sensor | C-band SAR |
| Product | GRD |
| Acquisition mode | IW |
| Polarization | VV + VH |
| Analysis | Historical pre/post-event comparison |
| Data source | ISRO Bhoonidhi |

**Actual acquisitions processed:**

| Acquisition date | Role |
|---|---|
| 2 October 2023 | Pre-event reference |
| 14 October 2023 | Post-event observation |

Both scenes were extracted, inspected for AOI coverage, and processed through the SNAP workflow.

The selected pair is a 12-day-separated observation pair around the 4 October 2023 event. The post-event acquisition is not an immediate observation of the event itself.

### 4.2 NISAR — S-band SAR

| Parameter | Details |
|---|---|
| Satellite | NISAR |
| Sensor | S-band SAR |
| Product family | NISAR_SSAR_W_GCOV_DH |
| Product type | GCOV |
| Polarization | HH + HV |
| Format | HDF5 |
| Output pixel spacing | 10 m |
| Data source | NISAR product archive |

**Acquisitions processed:**

| Date | Track | Frame |
|---|---:|---:|
| 24 August 2026 | 170 | 15 |
| 5 September 2026 | 170 | 15 |
| 29 September 2026 | 170 | 15 |

The NISAR branch investigates later surface conditions using S-band observations and multi-temporal backscatter analysis.

NISAR GCOV is a geocoded covariance product, not an SLC product. The current workflow does not claim interferometric displacement measurements.

These 2026 acquisitions must not be represented as immediate post-event imagery for the 2023 GLOF.

### 4.3 SRTM DEM — Terrain Information

| Parameter | Details |
|---|---|
| Dataset | SRTM 1 Arc-Second Global |
| Tile | N27E088 |
| Source file | N27E088.SRTMGL1.hgt.zip |
| Application | SNAP terrain correction |
| Purpose | Elevation-assisted geocoding and terrain correction |

The SRTM DEM was automatically retrieved by SNAP during Sentinel-1 terrain correction.

Terrain derivatives such as slope, drainage, and flow accumulation should be documented separately only when their corresponding analysis has actually been performed.

### 4.4 Rainfall and Meteorological Data

Rainfall is an important supporting variable for hydrological and flood-related research.

Potential sources for future integration include:
- INSAT-3DR rainfall products
- GPM IMERG
- ERA5-Land
- IMD rainfall datasets
- NASA POWER

Rainfall data must be documented with its actual product identifier, acquisition period, temporal resolution, spatial resolution, and processing history before being described as an input to a completed SARC analysis.

No rainfall-conditioned Sentinel-1 or NISAR result is claimed in the current completed research outputs.

### 4.5 Supporting Geospatial Data

Potential supporting datasets:
- River networks and drainage layers
- OpenStreetMap infrastructure and settlement data
- Additional DEM products
- Optical satellite observations
- Hydrological and meteorological datasets

The current Sentinel-1 OSM river-proximity analysis was not completed because Overpass requests returned HTTP 406/429 errors. No river-distance measurements are claimed.

## 5. Research and Processing Environment

**Primary environment**
- Google Colab
- ESA SNAP
- Python

**Geospatial and analytical libraries used in the research workflow**
- Rasterio
- NumPy
- GeoPandas
- GDAL
- Shapely
- Matplotlib
- Scikit-learn

Additional tools such as QGIS and OpenCV may support inspection and future development where required.

Software and library versions should be recorded with reproducible processing runs.

## 6. Sentinel-1 Processing Methodology

The Sentinel-1 GRD branch uses a separate processing workflow.

Implemented workflow:
1. SAFE archive extraction.
2. Product manifest and annotation inspection.
3. Acquisition and AOI footprint verification.
4. Pre/post-event pair identification.
5. SNAP orbit auxiliary handling.
6. Radiometric calibration to Sigma0 backscatter.
7. Terrain correction using SRTM elevation data.
8. AOI-specific GeoTIFF export.
9. Pre/post backscatter comparison.
10. VV/VH change analysis.
11. Median-based speckle suppression.
12. Robust change statistics.
13. VV/VH same-direction consensus analysis.
14. Connected-component candidate inventory.
15. Candidate polygon repair and GIS export.

The workflow uses the two selected Sentinel-1A GRD acquisitions dated 2 and 14 October 2023.

## 7. NISAR Processing Methodology

The NISAR branch is processed independently from Sentinel-1.

Implemented workflow:
1. GCOV HDF5 product inspection.
2. Product and acquisition metadata review.
3. AOI subset extraction.
4. HH/HV band inspection.
5. Valid-pixel and NoData assessment.
6. Multi-temporal backscatter analysis.
7. Feature engineering.
8. Exploratory clustering.
9. Statistical anomaly identification.
10. Spatial coherence assessment.
11. Anomaly inventory generation.
12. Research visualization and output export.

The processing respects the GCOV product representation. Sentinel-1 GRD operators are not blindly transferred to the NISAR branch.

## 8. Analytical Methods

### NISAR branch
- Multi-temporal backscatter statistics
- Feature engineering
- KMeans clustering
- Isolation Forest anomaly detection
- Spatial coherence analysis
- Anomaly inventory and mapping

The four KMeans clusters are exploratory groups, not verified land-cover or flood classes. Isolation Forest anomalies are statistical outliers, not confirmed hazard observations.

### Sentinel-1 branch
- Sigma0 backscatter comparison
- VV/VH change indicators
- 3 × 3 median speckle suppression
- Median Absolute Deviation (MAD)-based exploratory thresholds
- Same-direction VV/VH consensus
- Connected-component analysis
- Candidate polygon inventory

VV/VH agreement is not independent validation. MAD thresholds are exploratory and are not validated flood-detection thresholds.

## 9. Research Results

### Sentinel-1 — October 2023

| Metric | Result |
|---|---:|
| Scenes processed | 2 |
| AOI-intersecting scenes | 2 |
| Compatible pre/post pair | 1 |
| Consensus candidates | 37 |
| Total candidate area | 9.42 ha |
| River proximity analysis | Not performed |

The 37 consensus candidates represent spatial regions of same-direction VV/VH backscatter change under the selected analysis method.

The 9.42 ha value represents candidate polygon area, not confirmed flood-affected area.

### NISAR — 2026

The NISAR branch processed three S-band GCOV acquisitions and generated:
- Multi-temporal backscatter analysis
- 30 engineered features
- Four exploratory KMeans clusters
- Isolation Forest anomaly inventory
- Spatial coherence analysis
- Research maps and tabular outputs

The anomaly inventory represents statistical deviations in the analyzed feature space. It does not independently establish flood occurrence, damage, or landslide activity.

## 10. Scientific Interpretation and Limitations

The current research is exploratory and retrospective.

Important limitations:
- Only two Sentinel-1 GRD acquisitions were used in the current event-oriented comparison.
- The acquisitions are separated by 12 days.
- Backscatter change can be influenced by soil moisture, vegetation, rainfall, land-use activity, speckle, incidence angle, and residual geometric effects.
- The selected candidate regions are not verified flood extents.
- No independent ground-truth flood-extent validation has been completed.
- River proximity analysis was not completed.
- NISAR 2026 acquisitions cannot reconstruct the immediate October 2023 event.
- C-band VV/VH and S-band HH/HV values are not directly interchangeable.
- Pixel spacing must not be confused with effective spatial resolution.
- No operational flood forecast or validated warning threshold is claimed.

## 11. Cross-Sensor Research Strategy

Sentinel-1 and NISAR are maintained as independent sensor-specific analysis branches.

A meaningful future comparison requires:
- Temporally compatible acquisitions
- Common spatial coverage
- Consistent AOI definition
- Consideration of wavelength and frequency
- Polarization-aware analysis
- Incidence-angle and acquisition-geometry assessment
- Radiometric harmonization
- Appropriate spatial resampling
- Independent validation where possible

The current 2023 Sentinel-1 and 2026 NISAR outputs have not undergone a temporally matched cross-sensor validation experiment.

## 12. Platform Architecture

SARC is designed around a shared backend connecting two separate interfaces.

### Web Monitoring Dashboard

Intended users: research and monitoring teams.

Planned capabilities:
- Interactive geospatial map
- AOI and acquisition visualization
- Satellite layer inspection
- Pre/post-event comparison
- River and settlement context
- Change-indicator visualization
- Data-quality information
- Analysis history
- Human-review interface
- Advisory management

### Community-Facing Mobile Application

Intended users: residents and communities in relevant areas.

Planned capabilities:
- Community-oriented updates
- Localized advisories
- Safety information
- Emergency contact information
- Notification history
- Location-aware information where appropriate

Satellite-derived analytical signals must not automatically become official emergency warnings. Community-facing advisories should pass through suitable human review and authorized communication channels.

### Shared Backend

Conceptual responsibilities:
- Satellite acquisition metadata
- Geospatial layer management
- Analysis history
- User roles and permissions
- Advisory status and verification history
- Community notification management
- Secure data access

## 13. System Architecture

```text
Satellite & Supporting Data
            |
            v
  Sentinel-1 / NISAR
            |
            v
  Geospatial Processing
            |
            v
   Analytical Outputs
            |
            v
  Backend & Data Management
            |
      +-----+-----+
      |           |
      v           v
Web Dashboard  Mobile Application
      |
      v
Research Team Review
      |
      v
Verified Advisory Workflow
```

This architecture describes the intended platform workflow. Research processing outputs and proposed application capabilities are documented separately from deployed production functionality.

## 14. Repository Structure

Suggested organization:

```text
SARC/
├── README.md
├── docs/
│   ├── project-overview.md
│   ├── research-methodology.md
│   ├── data-sources.md
│   ├── processing-workflow.md
│   └── architecture.md
├── research/
│   ├── sentinel1/
│   └── nisar/
├── processing/
├── backend/
├── dashboard/
├── mobile-app/
├── assets/
├── notebooks/
└── .gitignore
```

The existing repository structure should be preserved unless a deliberate restructuring is required.

## 15. Research Data Management

Research data should be organized into:
- Original satellite products
- Extracted source data
- Processed rasters
- Analytical outputs
- GIS vector inventories
- Visualizations
- Metadata and reports

Raw satellite products should be preserved separately from generated outputs.

Large raw HDF5 and SAFE archives should not be committed directly to GitHub. API credentials, passwords, tokens, and private information must never be committed.

Processing parameters, acquisition dates, product identifiers, and software versions should be retained for reproducibility.

## 16. Future Research Priorities

1. Obtain additional compatible Sentinel-1 pre-event and post-event observations.
2. Validate the selected AOI and scene coverage against authoritative footprints.
3. Investigate independent flood-extent evidence for the 2023 event.
4. Incorporate documented rainfall and hydrological observations.
5. Develop river-corridor and settlement-exposure analysis.
6. Evaluate terrain derivatives where methodologically justified.
7. Investigate temporally compatible NISAR and Sentinel-1 observations.
8. Improve data-quality and confidence indicators.
9. Develop the common backend and monitoring dashboard.
10. Implement a human-reviewed community advisory workflow.

## 17. Final Project Definition

SARC is a research-driven, multi-sensor SAR and geospatial intelligence platform that investigates satellite-observed environmental changes, analyzes river-corridor and settlement exposure, and translates geospatial insights into useful information through a dedicated monitoring dashboard and a community-facing mobile application.

By combining historical Sentinel-1 event analysis, complementary NISAR S-band observations, terrain context, explainable geospatial indicators, and a human-reviewed information-delivery workflow, SARC aims to establish a scientifically responsible bridge between satellite intelligence, monitoring teams, and vulnerable communities.

**The central objective is not to make unsupported predictions, but to develop a scientifically responsible and practically useful geospatial information system.**
