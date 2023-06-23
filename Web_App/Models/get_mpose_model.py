import numpy as np

# PyTorch imports
import torch
import torchvision

from mmpose.apis import init_pose_model

def _convert_batchnorm(module):
    """Convert the syncBNs into normal BN3ds."""
    module_output = module
    if isinstance(module, torch.nn.SyncBatchNorm):
        module_output = torch.nn.BatchNorm3d(module.num_features, module.eps,
                                             module.momentum, module.affine,
                                             module.track_running_stats)
        if module.affine:
            module_output.weight.data = module.weight.data.clone().detach()
            module_output.bias.data = module.bias.data.clone().detach()
            # keep requires_grad unchanged
            module_output.weight.requires_grad = module.weight.requires_grad
            module_output.bias.requires_grad = module.bias.requires_grad
        module_output.running_mean = module.running_mean
        module_output.running_var = module.running_var
        module_output.num_batches_tracked = module.num_batches_tracked
    for name, child in module.named_children():
        module_output.add_module(name, _convert_batchnorm(child))
    del module
    return module_output

config_file = 'mmpose/configs/face/2d_kpt_sview_rgb_img/deeppose/wflw/res50_wflw_256x256.py'
checkpoint_file = 'deeppose_res50_wflw_256x256-92d0ba7f_20210303.pth'
model = init_pose_model(config_file, checkpoint_file, device='cpu') 
model = _convert_batchnorm(model)
model = model.eval()

# implement the forward method
if hasattr(model, 'forward_dummy'):
    model.forward = model.forward_dummy

# We grab the TorchScripted model via tracing
input_shape = [1, 3, 256, 256]
input_data = torch.randn(input_shape)
scripted_model = torch.jit.trace(model, input_data).eval()

scripted_model.save('deeppose.pt')# Save
print("Torch model saved to ./deeppose.pt")
