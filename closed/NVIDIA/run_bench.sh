#MLPERF_SCRATCH_PATH=/work
mkdir -p $LOG_DIR
make build
make download_model # Downloads models and saves to $MLPERF_SCRATCH_PATH/models
make download_data # Downloads datasets and saves to $MLPERF_SCRATCH_PATH/data
make preprocess_data # Preprocess data and saves to $MLPERF_SCRATCH_PATH/preprocessed_data

#BENCHMARK=bert or resnet50 ssd-resnet34 ssd-mobilenet bert dlrm rnnt 3d-unet
#SCENARIO=Offline or Server SingleStream MultiStream
#CONFIG_VER =default,high_accuracy,triton, high_accuracy_triton,all
#Uses Triton Inference Server to run the benchmark for the 99.9% of FP32 accuracy target. Supported only for DLRM and 3D-Unet.
#https://github.com/mlperf/inference_results_v0.7/blob/master/closed/NVIDIA/command_flags.md#run_args-flags
#all: Runs every config_ver available in config.json. This will override all other config_ver options specified by the flag.
make info >> $LOG_DIR/build_info.txt
THIS_BENCHMARKS=$(echo $BENCHMARKS | tr -s '[:blank:]' ',')

make generate_engines RUN_ARGS="--benchmarks=$THIS_BENCHMARKS --scenarios=$SCENARIOS"
#--test_mode=[PerformanceOnly,AccuracyOnly]
# LOG_DIR=/var/log/benchmark
# --log_copy_detail_to_stdout
mkdir -p /work/log/mlperf/
touch /work/log/mlperf/perf_harness_summary.json
make run_harness RUN_ARGS="--benchmarks=$THIS_BENCHMARKS --scenarios=$SCENARIOS --test_mode=$TEST_MODE"
