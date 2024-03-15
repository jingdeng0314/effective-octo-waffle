rule plot_heads:
    input:
        path_head_nc = "data/5-visualization/groundwater_heads.nc"
    output:
        path_figure = "reports/figures/groundwater_heads.png"
    script:
        "src/5-visualize/5-plot.py"

rule post_process:
    input:
        path_hds = "data/4-output/GWF.hds",
        path_grb = "data/4-output/dis.dis.grb",
    output:
        path_head_nc = "data/5-visualization/groundwater_heads.nc"
    script:
        "src/4-analyze/4-post-process.py"

rule run_model:
    input:
        path_model = "data/3-input/mfsim.nam"
    output:
        path_hds = "data/4-output/GWF.hds",
        path_grb = "data/4-output/dis.dis.grb",
    shell:
        "cd data\\3-input && call ..\\..\\bin\\mf6.exe . && move GWF\\GWF.hds ..\\4-output\\GWF.hds && move GWF\\dis.dis.grb ..\\4-output\\dis.dis.grb"

rule build_model:
    input:
        path_discretization = "data/2-interim/discretization.nc",
        path_drn_pkg = "data/2-interim/drn_pkg.nc",
        path_riv_pkg = "data/2-interim/riv_pkg.nc",
        path_recharge =  "data/2-interim/recharge.nc",
        path_ic = "data/2-interim/ic.nc",
        path_chd = "data/2-interim/chd.nc",
        path_subsurface = "data/2-interim/subsurface.nc",
    output:
        path_model = "data/3-input/mfsim.nam"
    script:
        "src/2-build/2-build-model.py"

rule surface_water:
    input:
        path_drainage = "data/1-external/drainage.nc",
        path_river = "data/1-external/river.nc",
    output:
        path_drn_pkg = "data/2-interim/drn_pkg.nc",
        path_riv_pkg = "data/2-interim/riv_pkg.nc",
    script:
        "src/1-prepare/1-surface-water.py"

rule recharge:
    input:
        path_meteorology = "data/1-external/meteorology.nc",
        path_discretization = "data/2-interim/discretization.nc",
    output:
        path_recharge = "data/2-interim/recharge.nc",
    script:
        "src/1-prepare/1-recharge.py"

rule initial_condition:
    input:
        path_starting_heads = "data/1-external/starting_heads.nc",
        path_discretization = "data/2-interim/discretization.nc",
    output:
        path_ic = "data/2-interim/ic.nc",
        path_chd = "data/2-interim/chd.nc",
    script:
        "src/1-prepare/1-initial-condition.py"

rule subsurface:
    input:
        path_layermodel = "data/1-external/layermodel.nc",
    output:
        path_subsurface = "data/2-interim/subsurface.nc",
    script:
        "src/1-prepare/1-subsurface.py"

rule discretization:
    input:
        path_layermodel = "data/1-external/layermodel.nc",
    output:
        path_discretization = "data/2-interim/discretization.nc",
    script:
        "src/1-prepare/1-discretization.py"

rule download_data:
    output:
        path_layermodel = "data/1-external/layermodel.nc",
        path_starting_heads = "data/1-external/starting_heads.nc",
        path_meteorology = "data/1-external/meteorology.nc",
        path_drainage = "data/1-external/drainage.nc",
        path_river = "data/1-external/river.nc",
    script:
        "src/0-setup/0-download-data.py"
