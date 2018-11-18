require 'nn'
require 'nngraph'
require 'image'
require 'utils'
torch.setdefaulttensortype( 'torch.FloatTensor' )

-- commandline options
cmd = torch.CmdLine()
cmd:addTime()
cmd:text()
cmd:option( '--input',           'none',        'Input image' )
cmd:option( '--mask',            'none',        'Mask image')

local opt = cmd:parse(arg or {})
print(opt)
assert( opt.input ~= 'none' )
print( 'Loding model...' )

-- load Completion Network
local data = torch.load( 'completionnet_places2.t7' )
local model    = data.model
local datamean  = data.mean
model:evaluate()

--  load data
local maxdim = 500
local I = image.load( opt.input )
local M = torch.Tensor()
if opt.mask~='none' then
   M = load_image_gray( opt.mask )
   assert( I:size(2) == M:size(2) and I:size(3) == M:size(3) )
else
   -- generate random holes
   M = torch.Tensor( 1, I:size(2), I:size(3) ):fill(0)
   local nHoles = torch.random( 2, 4 )
	for i=1,nHoles do
		local mask_w = torch.random( 32, 128 )
		local mask_h = torch.random( 32, 128 )
		local px = torch.random(1, I:size(3)-mask_w-1)
		local py = torch.random(1, I:size(2)-mask_h-1)
		local R = {{},{py,py+mask_h},{px,px+mask_w}}
		M[R]:fill(1)
	end 
end

local hwmax = math.max( I:size(2), I:size(3) )
if hwmax > maxdim then
	I = image.scale( I, string.format('*%d/%d',maxdim,hwmax) )
   M = image.scale( M, string.format('*%d/%d',maxdim,hwmax) )
end

--Set up input
I = image.scale( I, torch.round(I:size(3)/4)*4, torch.round(I:size(2)/4)*4 )
M = image.scale( M, torch.round(M:size(3)/4)*4, torch.round(M:size(2)/4)*4 ):ge(0.2):float()
local Ip = I:clone()
for j=1,3 do I[j]:add( -datamean[j] ) end
I:maskedFill( torch.repeatTensor(M:byte(),3,1,1), 0 )

-- inpaint target holes
print('Inpainting...')
local input = torch.cat(I, M, 1)
input = input:reshape( 1, input:size(1), input:size(2), input:size(3) )
local res = model:forward( input ):float()[1]
local out = Ip:cmul(torch.repeatTensor((1-M),3,1,1)) + res:cmul(torch.repeatTensor(M,3,1,1))

-- save output
for j=1,3 do I[j]:add( datamean[j] ) end
image.save('input.png', I)
image.save('out.png', out)

print('Done.')
