# SARC — MASTER PROJECT CONTEXT & DEVELOPMENT BRIEF

## 1. Project Identity

**Project Name:** SARC

**Domain:** Synthetic Aperture Radar (SAR), Earth Observation, Remote Sensing, Geospatial Intelligence, Disaster Monitoring and Community Safety.

**Core Vision:**

SARC is a research-driven, multi-sensor satellite intelligence platform designed to monitor river systems, observe environmental and terrain-related changes, identify potentially exposed areas, and communicate useful geospatial information to both monitoring teams and local communities.

The project combines satellite observations, geospatial processing, analytical interpretation, a centralized backend, a web-based monitoring dashboard, and a community-facing mobile application.

SARC is intended to bridge the gap between satellite-derived information and practical, understandable information for people living in potentially vulnerable areas.

---

## 2. Primary Research Study

**Primary Event:** 4 October 2023 — South Lhonak Lake GLOF, Sikkim.

**Study Region:** Teesta River Basin, Sikkim, India.

**Research Focus:**
- Observe changes associated with the 2023 GLOF event.
- Analyze river and surrounding land-surface conditions using SAR observations.
- Investigate possible changes in water-related backscatter patterns.
- Examine riverbank and surrounding settlement exposure.
- Explore the complementary use of C-band Sentinel-1 and S-band NISAR observations.
- Develop an explainable geospatial workflow that can eventually support community-oriented monitoring.

Important: The study must establish whether the selected downstream AOI was actually affected by the event using suitable satellite observations and independent evidence. Do not assume inundation or damage merely because the area lies downstream.

---

## 3. Area of Interest (AOI)

Current candidate AOI:

**Singtam–Majitar–Rangpo downstream region**

Coordinate reference: WGS84 / EPSG:4326

```text
North: 27.2025
South: 27.1575
West:  88.4897
East:  88.5403
```

This is the current compact candidate bounding box, approximately 5 km × 5 km.

Objectives:
- Focus on the Teesta river corridor and nearby settlements.
- Keep the AOI compact enough to fit within an individual usable satellite scene.
- Avoid spatial mosaicking.
- Use the same AOI for comparable pre-event and post-event analysis.

**AOI status:** Candidate coordinates; actual scene coverage and exact river/settlement inclusion must be verified.

Do not replace these coordinates with the older broad Teesta Basin search box or the separate 2026 Mangan landslide area.

---

## 4. Satellite Data Strategy

SARC follows a multi-sensor approach.

### A. Sentinel-1 — Historical Event Analysis

Satellite: Sentinel-1A

Sensor: C-band SAR

Primary product target:
- GRD
- IW acquisition mode
- VV + VH polarization

Purpose:
- Historical pre-event and post-event observations for the October 2023 GLOF.
- Water-related backscatter analysis.
- River corridor and surrounding land-surface change investigation.

Candidate search windows:

**Pre-event**
- 25 September – 30 September 2023
- 28 September 2023 is a priority candidate.

**Post-event**
- 5 October – 12 October 2023
- 7 October 2023 is a priority candidate.

These are search priorities, not confirmed downloadable scene selections.

Before selecting a pair, verify:
1. Actual acquisition date.
2. Scene footprint and complete AOI coverage.
3. Relative orbit number.
4. Ascending or descending orbit.
5. Acquisition mode.
6. VV/VH availability.
7. Incidence-angle and geometry compatibility.
8. Data quality.

Prefer matching relative orbit and acquisition geometry for pre/post comparison.

Data source: ISRO Bhoonidhi.

### B. NISAR — S-band Satellite Analysis

Satellite: NISAR

Sensor: S-SAR (S-band).

Product family:
`NISAR_SSAR_W_GCOV_DH`

Product type: GCOV (Geocoded Covariance Product)

Polarization: HH + HV

Image format: HDF5

Output pixel spacing: 10 m

Purpose:
- Explore S-band observations of the study region.
- Analyze later surface conditions.
- Investigate the potential of S-band observations for river/environmental monitoring.
- Support a complementary sensor-characterization study against Sentinel-1.

Previously identified candidate acquisitions:

| Date | Track | Frame | Product |
|---|---:|---:|---|
| 24 Aug 2026 | 170 | 15 | PR GCOV DH |
| 5 Sep 2026 | 170 | 15 | PR GCOV DH |
| 29 Sep 2026 | 170 | 15 | PR GCOV DH |

These are candidate products. Their actual footprint overlap with the current AOI must be verified before analysis.

Important distinction:
NISAR observations from 2026 cannot be presented as immediate post-event imagery for a 2023 GLOF. They are later observations and may support a separate temporal or sensor-comparison investigation.

### C. Sensor Comparison Limitations

Sentinel-1 C-band VV/VH and NISAR S-band HH/HV are not directly interchangeable.

Do not simply subtract their pixel values or treat their backscatter values as equivalent.

A scientifically meaningful comparison requires consideration of:
- Frequency and wavelength differences.
- Polarization differences.
- Incidence angle.
- Acquisition geometry.
- Spatial resolution and pixel spacing.
- Radiometric calibration and normalization.
- Temporal separation.
- Product representation and processing level.

Keep the 2023 event analysis and the cross-sensor comparison as distinct research questions.

---

## 5. Satellite Processing Workflow

### Sentinel-1 Processing

The Sentinel-1 GRD processing workflow should be developed and validated independently.

Potential workflow:

1. Read Sentinel-1 GRD product.
2. Inspect metadata and acquisition geometry.
3. Apply orbit file where appropriate.
4. Remove border noise where appropriate.
5. Apply thermal noise removal where applicable.
6. Calibrate to a suitable backscatter representation.
7. Apply suitable speckle filtering if justified.
8. Apply terrain correction if required.
9. Subset the AOI.
10. Export suitable analysis bands to GeoTIFF.
11. Perform pre/post-event analysis.

Do not assume every processing operation is required for every product. Verify product characteristics and SNAP operator compatibility.

### NISAR Processing

NISAR GCOV processing is a separate workflow.

Current progress:
- NISAR GCOV HDF5 product opened in ESA SNAP.
- AOI subset/crop completed.

Next tasks:
1. Inspect the Product Explorer.
2. Identify HH, HV and available covariance layers.
3. Visualize individual bands.
4. Check valid pixels and NoData.
5. Review statistics and histograms.
6. Assess speckle/noise characteristics.
7. Test filtering only if appropriate.
8. Preserve original and processed outputs separately.
9. Perform suitable backscatter analysis.
10. Export analysis-ready outputs to GeoTIFF.

Do not blindly apply the Sentinel-1 GRD processing chain to NISAR GCOV.

GCOV is not an SLC product. Do not assume it retains the phase information required for interferometric displacement analysis.

Do not independently filter covariance matrix components without verifying the suitability of the method.

### Processing Principles

- No spatial mosaicking for the current study.
- Multiple acquisition dates are allowed for temporal analysis.
- Preserve original satellite products.
- Save each intermediate processing output separately.
- Record processing parameters and software versions.
- Maintain reproducibility.
- Never overwrite original input data.

---

## 6. Analytical Layer

SARC should convert processed satellite observations into interpretable geospatial information.

Potential analytical components:

- Water-related backscatter indicators.
- Pre-event versus post-event change indicators.
- River corridor and riverbank analysis.
- Terrain and elevation context.
- Settlement proximity and exposure analysis.
- Spatial change visualization.
- Data-quality and confidence indicators.

Potential future supporting data:
- DEM and terrain derivatives.
- River network and drainage information.
- OpenStreetMap settlement and infrastructure layers.
- Relevant rainfall and hydrological datasets.
- Additional optical satellite observations where useful.

All analytical outputs must distinguish:
1. Satellite-observed change.
2. Algorithmically derived indicators.
3. Interpreted potential exposure.
4. Independently verified hazard information.
5. Official warnings issued by authorized authorities.

Do not present a satellite-derived change indicator as a confirmed flood, damage report, or validated forecast.

---

## 7. Web-Based Monitoring Dashboard

SARC includes a dedicated web dashboard for research and monitoring teams.

Main purpose:
Provide a centralized interface to inspect satellite-derived information, analyze changes, review potentially exposed areas, and manage information before it reaches communities.

Potential modules:

- Interactive geospatial map.
- AOI visualization.
- Satellite acquisition information.
- Pre-event and post-event layer comparison.
- NISAR and Sentinel-1 layer visualization.
- River and settlement layers.
- Change indicator visualization.
- Data-quality/confidence information.
- Analysis history.
- Review and verification interface.
- Community advisory management.

The dashboard is intended primarily for the monitoring/research team, not as a public-facing alert interface.

---

## 8. Community-Facing Mobile Application

SARC also includes a separate mobile application for people living in relevant communities.

Purpose:
Make useful and understandable location-specific information accessible to residents.

Potential features:

- Community-oriented updates.
- Localized advisories.
- Relevant safety information.
- Notifications and notification history.
- Important emergency contact information.
- Location-aware information where appropriate.
- Simple map and affected-area information.

The application should communicate information in understandable language.

**Important safety distinction:**
Satellite-derived analytical signals must not automatically become official emergency warnings. Community-facing advisories should pass through appropriate verification and authorized review processes.

The application complements official disaster-management communication channels; it does not replace them.

Location privacy and protection of resident data must be considered from the beginning.

---

## 9. Backend and System Architecture

The web dashboard and mobile application should use a common backend.

Conceptual architecture:

```text
Satellite Data
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
Backend / Data Management
     |
     +-----------------------+
     |                       |
     v                       v
Web Dashboard          Mobile Application
     |                       |
Team Analysis          Community Updates
     |
Human Review
     |
Verified Advisory Workflow
```

Backend responsibilities:
- Store analysis metadata.
- Manage AOI and satellite acquisition records.
- Serve geospatial layers.
- Maintain analysis history.
- Manage user roles and permissions.
- Handle community notifications.
- Maintain advisory status and verification history.

The implementation should be modular, secure, and maintainable.

---

## 10. Research Objectives

The project should investigate the following questions:

1. Can Sentinel-1 SAR observations reveal meaningful water-related surface changes associated with the October 2023 GLOF in the selected downstream AOI?
2. What differences can be observed between pre-event and post-event SAR imagery?
3. How can river corridor and settlement exposure be represented using geospatial analysis?
4. What additional observations can NISAR S-band imagery provide for later-condition monitoring?
5. What are the limitations of comparing Sentinel-1 C-band and NISAR S-band observations?
6. How can satellite-derived analytical information be communicated through a dashboard and a community-facing mobile application?

---

## 11. Technology Stack

The final stack can be selected according to implementation needs.

Research and processing:
- ESA SNAP
- Python
- Google Colab
- Rasterio
- GDAL
- GeoPandas
- NumPy
- OpenCV where relevant
- QGIS for GIS inspection and visualization

Satellite data:
- ISRO Bhoonidhi
- NISAR
- Sentinel-1

Application:
- Web dashboard
- Mobile application
- Shared backend
- Geospatial map visualization
- Database and geospatial data management

Use the existing repository's framework and conventions wherever possible. Do not introduce unnecessary frameworks or rewrite working components without reason.

---

## 12. GitHub Repository and Collaboration Instructions

The repository should communicate the complete SARC concept and maintain a clean, reproducible project structure.

Suggested organization:

```text
SARC/
│
├── README.md
├── docs/
│   ├── project-overview.md
│   ├── research-methodology.md
│   ├── data-sources.md
│   ├── processing-workflow.md
│   └── architecture.md
│
├── research/
│   ├── sentinel1/
│   └── nisar/
│
├── processing/
│
├── backend/
│
├── dashboard/
│
├── mobile-app/
│
├── assets/
│
├── notebooks/
│
└── .gitignore
```

This is a suggested structure. Inspect the existing repository before changing folders or moving files.

### Git Commit Guidelines

- Do not delete existing working code.
- Do not overwrite another collaborator's work.
- Do not commit passwords, API keys, tokens, or private credentials.
- Do not upload large raw satellite HDF5/ZIP files to Git.
- Do not commit temporary SNAP cache files or unnecessary intermediate raster files.
- Keep research documentation and source code organized.
- Include data source, acquisition date, product ID, and processing metadata in documentation.
- Use descriptive commit messages.
- Check `git status` and review the diff before committing.
- Keep changes modular and explain what has actually been implemented.

Suggested commit message:

`docs: add SARC project context and research methodology`

Only use this commit message if the changes are documentation-only.

---

## 13. Scientific and Development Guardrails

1. Do not claim validated flood prediction.
2. Do not claim confirmed damage without independent evidence.
3. Do not treat 2026 NISAR data as immediate post-event imagery for the 2023 GLOF.
4. Do not directly compare C-band and S-band values without methodological harmonization.
5. Do not claim that every selected satellite scene covers the AOI until the footprint is verified.
6. Do not confuse pixel spacing with effective spatial resolution.
7. Do not create spatial mosaics for the current study.
8. Preserve raw and intermediate data.
9. Clearly distinguish current implemented features from proposed future features.
10. Keep the community notification workflow responsible, explainable, and human-reviewed.

---

## 14. Current Project Status and Immediate Priorities

**Completed / established:**
- Project name finalized as SARC.
- Primary research event selected: 4 October 2023 South Lhonak GLOF.
- Current compact downstream candidate AOI established.
- NISAR S-band GCOV candidate products identified.
- NISAR HDF5 product opened in SNAP.
- NISAR AOI subset completed.
- Sentinel-1 historical pre/post-event search plan established.
- Dashboard and community mobile application defined as separate interfaces connected through a common backend.

**In progress:**
- Inspect NISAR subset bands and statistics.
- Assess whether filtering is necessary.
- Search Bhoonidhi for compatible Sentinel-1 pre-event and post-event scenes.
- Verify actual scene footprint and relative orbit compatibility.
- Build and validate processing workflows.
- Develop application and dashboard architecture.

**Immediate priority:**
Obtain a compatible Sentinel-1 pre-event/post-event pair covering the current AOI, then process and analyze the data independently from the NISAR 2026 observations.

---

## Final Project Definition

**SARC is a research-driven, multi-sensor SAR and geospatial intelligence platform that investigates satellite-observed environmental changes, analyzes river-corridor and settlement exposure, and translates geospatial insights into actionable information through a dedicated monitoring dashboard and a community-facing mobile application.**

The project combines historical Sentinel-1 event analysis, complementary NISAR S-band observations, geospatial processing, explainable analytical indicators, and a human-reviewed information-delivery workflow.

The central objective is not to make unsupported predictions, but to develop a scientifically responsible and practically useful bridge between satellite intelligence, monitoring teams, and vulnerable communities.
