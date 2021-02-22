# Copyright (c) 2020, NVIDIA CORPORATION.  All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# (system_id, gpu_name_from_driver, gpu_count)
system_list = ([
    ("T4x1", "Tesla T4", 1),
    ("T4x2", "Tesla T4", 2),
    ("T4x3", "Tesla T4", 3),
    ("T4x4", "Tesla T4", 4),
    ("T4x8", "Tesla T4", 8),
    ("T4x20", "Tesla T4", 20),
    ("TitanRTXx4", "TITAN RTX", 4),
    ("V100-PCIex1", "V100-PCIE-16GB", 1),
    ("V100S-PCIex1", "V100S-PCIE-32GB", 1),
    ("A100-PCIex1", "A100-PCIE-40GB", 1),
    ("A100-SXM4x1", "Graphics Device", 1),
    ("A100-SXM4x1", "A100-SXM4-40GB", 1),
    ("A100-SXM4x1-MIG_1x1g.5gb", "A100-SXM4-40GB", 1),
    ("A100-SXM4x8", "A100-SXM4-40GB", 8),
    ("AGX_Xavier", "Jetson-AGX", 1),
    ("Xavier_NX", "Xavier NX", 1)
])
