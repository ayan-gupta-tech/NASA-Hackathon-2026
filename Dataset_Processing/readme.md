Sentinel-1 SAR Data Preprocessing Using ESA SNAP
Overview
This project focuses on the preprocessing and visualization of Sentinel-1 Synthetic Aperture Radar (SAR) data using ESA SNAP (Sentinel Application Platform).

Sentinel-1 SAR data is used for Earth observation and surface monitoring. This work involves processing Sentinel-1 IW GRDH data and visualizing the VV and VH polarization bands.

Software Used
ESA SNAP 14 – Sentinel-1 SAR data processing and visualization.
Sentinel-1 SAR – Synthetic Aperture Radar satellite data.
GeoTIFF – Raster data format for storing processed outputs.
Dataset Information
Satellite: Sentinel-1
Sensor: C-band SAR
Acquisition Mode: Interferometric Wide Swath (IW)
Product Type: Ground Range Detected High Resolution (GRDH)
Polarizations: VV and VH
Study Area: Uttarakhand, India
Data Format: GeoTIFF
Processing Overview
The Sentinel-1 SAR data was opened and visualized in ESA SNAP 14.

The workflow includes:

Importing Sentinel-1 IW GRDH satellite data into ESA SNAP.
Accessing the VV and VH polarization bands.
Visualizing Sigma0_VV and Sigma0_VH backscatter images.
Working with the raster output in GeoTIFF format.
Visualizing the SAR data over the Uttarakhand study area.
Sentinel-1-SAR-Preprocessing/
│
├── README.md
│
├── images/
│   └── ESA_SNAP_preprocessing.png
│
├── data/
│   └── processed_data.tif
│
└── outputs/
    ├── Sigma0_VV
    └── Sigma0_VH
