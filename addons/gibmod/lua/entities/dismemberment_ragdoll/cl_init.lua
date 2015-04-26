include("shared.lua")

LeftFingerList = {"ValveBiped.Bip01_L_Finger0",
	"ValveBiped.Bip01_L_Finger01",
	"ValveBiped.Bip01_L_Finger02",
	"ValveBiped.Bip01_L_Finger1",
	"ValveBiped.Bip01_L_Finger11",
	"ValveBiped.Bip01_L_Finger12",
	"ValveBiped.Bip01_L_Finger2",
	"ValveBiped.Bip01_L_Finger21",
	"ValveBiped.Bip01_L_Finger22",
	"ValveBiped.Bip01_L_Finger3",
	"ValveBiped.Bip01_L_Finger31",
	"ValveBiped.Bip01_L_Finger32",
	"ValveBiped.Bip01_L_Finger4",
	"ValveBiped.Bip01_L_Finger41",
	"ValveBiped.Bip01_L_Finger42"}
	
RightFingerList = {"ValveBiped.Bip01_R_Finger0",
	"ValveBiped.Bip01_R_Finger01",
	"ValveBiped.Bip01_R_Finger02",
	"ValveBiped.Bip01_R_Finger1",
	"ValveBiped.Bip01_R_Finger11",
	"ValveBiped.Bip01_R_Finger12",
	"ValveBiped.Bip01_R_Finger2",
	"ValveBiped.Bip01_R_Finger21",
	"ValveBiped.Bip01_R_Finger22",
	"ValveBiped.Bip01_R_Finger3",
	"ValveBiped.Bip01_R_Finger31",
	"ValveBiped.Bip01_R_Finger32",
	"ValveBiped.Bip01_R_Finger4",
	"ValveBiped.Bip01_R_Finger41",
	"ValveBiped.Bip01_R_Finger42"}
	
VortLeftFingerList = {"ValveBiped.index1_L",
	"ValveBiped.index2_L",
	"ValveBiped.index3_L",
	"ValveBiped.pinky1_L",
	"ValveBiped.pinky2_L",
	"ValveBiped.pinky3_L"}
	
VortRightFingerList = {"ValveBiped.index1_R",
	"ValveBiped.index2_R",
	"ValveBiped.index3_R",
	"ValveBiped.pinky1_R",
	"ValveBiped.pinky2_R",
	"ValveBiped.pinky3_R"}
	
LeftUpperArmList = {"ValveBiped.Bip01_L_UpperArm",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_L_Bicep",
	"ValveBiped.Bip01_L_Wrist",
	"ValveBiped.Bip01_L_Elbow",
	"ValveBiped.Bip01_L_Ulna",
	//Vort
	"ValveBiped.arm1_l",
	"ValveBiped.arm2_l",
	"ValveBiped.hlp_ulna_L",
	"ValveBiped.hlp_wrist_L"
	}
	
LeftForeArmList = {"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_L_Wrist",
	"ValveBiped.Bip01_L_Ulna",
	//Vort
	"ValveBiped.arm2_l",
	"ValveBiped.hlp_ulna_L",
	"ValveBiped.hlp_wrist_L"}

RightUpperArmList = {"ValveBiped.Bip01_R_UpperArm",
	"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_R_Bicep",
	"ValveBiped.Bip01_R_Wrist",
	"ValveBiped.Bip01_R_Elbow",
	"ValveBiped.Bip01_R_Ulna",
	//Vort
	"ValveBiped.arm1_r",
	"ValveBiped.arm2_r",
	"ValveBiped.hlp_ulna_R",
	"ValveBiped.hlp_wrist_R"}
	
RightForeArmList = {"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_R_Wrist",
	"ValveBiped.Bip01_R_Ulna",
	//Vort
	"ValveBiped.arm2_r",
	"ValveBiped.hlp_ulna_R",
	"ValveBiped.hlp_wrist_R"}
	
LeftThighList = {"ValveBiped.Bip01_L_Thigh",
	"ValveBiped.Bip01_L_Calf",
	"ValveBiped.Bip01_L_Foot",
	"ValveBiped.Bip01_L_Toe0",
	//Vort
	"ValveBiped.leg_bone1_l",
	"ValveBiped.leg_bone2_l",
	"ValveBiped.leg_bone3_l"}
	
LeftUpperCalfList = {
	//Vort
	"ValveBiped.leg_bone2_l",
	"ValveBiped.leg_bone3_l",
	"ValveBiped.Bip01_L_Foot",
	"ValveBiped.Bip01_L_Toe0"}
	
LeftCalfList = {"ValveBiped.Bip01_L_Calf",
	"ValveBiped.Bip01_L_Foot",
	"ValveBiped.Bip01_L_Toe0",	
	//Vort
	"ValveBiped.leg_bone3_l"}
	
RightThighList = {"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_R_Foot",
	"ValveBiped.Bip01_R_Toe0",
	//Vort
	"ValveBiped.leg_bone1_r",
	"ValveBiped.leg_bone2_r",
	"ValveBiped.leg_bone3_r"}
	
RightUpperCalfList = {
	//Vort
	"ValveBiped.leg_bone2_r",
	"ValveBiped.leg_bone3_r",
	"ValveBiped.Bip01_R_Foot",
	"ValveBiped.Bip01_R_Toe0"}
	
RightCalfList = {"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_R_Foot",
	"ValveBiped.Bip01_R_Toe0",
	//Vort
	"ValveBiped.leg_bone3_r"}
	
function ENT:Initialize()
	self:AddCallback("BuildBonePositions", DismembermentBuildBonePositions)
end

function ENT:Think()
	self:DrawModel()
	local ragdoll = self:GetNetworkedEntity("dismembermentragdoll")
end

function DismembermentBuildBonePositions(self, NumBones, NumPhysBones)
	ragdoll = self:GetNetworkedEntity("dismembermentragdoll")
	if ragdoll:IsValid() then
		for bone = 0, ragdoll:GetBoneCount() do
			if ragdoll:GetNetworkedBool("IsLimb") and ragdoll:GetNetworkedString("LimbParent") != nil and !ragdoll:GetNWBool("LimbExclude" .. bone) then
				local function LimbScale(scalebone)
					local BoneMatrix = ragdoll:GetBoneMatrix(scalebone)
					if BoneMatrix != nil then
						BoneMatrix:Scale(vector_origin)
						BoneMatrix:SetTranslation(ragdoll:GetBoneMatrix(ragdoll:LookupBone(ragdoll:GetNetworkedString("LimbParent"))):GetTranslation())
						ragdoll:SetBoneMatrix(scalebone, BoneMatrix)
					end
				end
				
				//Head and Vort Head
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.Bip01_Head1" or ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.head" then
					LimbScale(bone)
				end
				
				//Left Upperarm
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.Bip01_L_UpperArm" and !table.HasValue(LeftUpperArmList, ragdoll:GetBoneName(bone)) and !table.HasValue(LeftFingerList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Vort Left Upperarm
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.arm1_l" and !table.HasValue(LeftUpperArmList, ragdoll:GetBoneName(bone)) and !table.HasValue(VortLeftFingerList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Left Forearm
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.Bip01_L_Forearm" and !table.HasValue(LeftForeArmList, ragdoll:GetBoneName(bone)) and !table.HasValue(LeftFingerList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Vort Left Forearm
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.arm2_l" and !table.HasValue(LeftForeArmList, ragdoll:GetBoneName(bone)) and !table.HasValue(VortLeftFingerList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Right Upperarm
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.Bip01_R_UpperArm" and !table.HasValue(RightUpperArmList, ragdoll:GetBoneName(bone)) and !table.HasValue(RightFingerList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Vort Right Upperarm
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.arm1_r" and !table.HasValue(RightUpperArmList, ragdoll:GetBoneName(bone)) and !table.HasValue(VortRightFingerList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Right Forearm
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.Bip01_R_Forearm" and !table.HasValue(RightForeArmList, ragdoll:GetBoneName(bone)) and !table.HasValue(RightFingerList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Vort Right Forearm
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.arm2_r" and !table.HasValue(RightForeArmList, ragdoll:GetBoneName(bone)) and !table.HasValue(VortRightFingerList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Left Thigh
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.Bip01_L_Thigh" and !table.HasValue(LeftThighList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Vort Left Thigh
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.leg_bone1_l" and !table.HasValue(LeftThighList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Vort Left Upper Calf
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.leg_bone2_l" and !table.HasValue(LeftUpperCalfList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Left Calf
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.Bip01_L_Calf" and !table.HasValue(LeftCalfList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Vort Left Calf
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.leg_bone3_l" and !table.HasValue(LeftCalfList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Right Thigh
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.Bip01_R_Thigh" and !table.HasValue(RightThighList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Vort Right Thigh
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.leg_bone1_r" and !table.HasValue(RightThighList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Vort Right Upper Calf
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.leg_bone2_r" and !table.HasValue(RightUpperCalfList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Right Calf
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.Bip01_R_Calf" and !table.HasValue(RightCalfList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
				
				//Vort Right Calf
				if ragdoll:GetNetworkedString("LimbParent") == "ValveBiped.leg_bone3_r" and !table.HasValue(RightCalfList, ragdoll:GetBoneName(bone)) then
					LimbScale(bone)
				end
			end
			
			if ragdoll:GetNWBool("boneisgibbed" .. bone) and !ragdoll:GetNWBool("SpecLimbExclude" .. bone) then
				local function ScaleBoneChildren(ent, bone, scale)
					local children = ent:GetChildBones(bone)
			
					for k, v in pairs(children) do
						local ChildBoneMatrix = ent:GetBoneMatrix(bone)
						if ChildBoneMatrix != nil then
							ChildBoneMatrix:Scale(vector_origin)
							ChildBoneMatrix:SetTranslation(ent:GetBoneMatrix(ent:GetBoneParent(v)):GetTranslation())
							ent:SetBoneMatrix(v, ChildBoneMatrix)
						end
					end
				end
				
				local function ScaleBone(ent, bone)
					local BoneMatrix = ent:GetBoneMatrix(bone)
					
					if BoneMatrix != nil then
						BoneMatrix:Scale(vector_origin)
						//BoneMatrix:SetTranslation(ent:GetBoneMatrix(ent:GetBoneParent(bone)):GetTranslation())
						ent:SetBoneMatrix(bone, BoneMatrix)
						ScaleBoneChildren(ent, bone, vector_origin)
					end
				end
				
				ScaleBone(ragdoll, bone, bone)
				
				if ragdoll:GetBoneName(bone) == "ValveBiped.Bip01_L_Hand" then
					for k, v in pairs(LeftFingerList) do
						if ragdoll:LookupBone(v) != nil then
							ragdoll:SetBoneMatrix(ragdoll:LookupBone(v), ragdoll:GetBoneMatrix(ragdoll:LookupBone("ValveBiped.Bip01_L_Hand")))
						end
					end
				end
				
				if ragdoll:GetBoneName(bone) == "ValveBiped.Bip01_R_Hand" then
					for k, v in pairs(RightFingerList) do
						if ragdoll:LookupBone(v) != nil then
							ragdoll:SetBoneMatrix(ragdoll:LookupBone(v), ragdoll:GetBoneMatrix(ragdoll:LookupBone("ValveBiped.Bip01_R_Hand")))
						end
					end
				end
				
				if ragdoll:GetBoneName(bone) == "ValveBiped.hand1_L" then
					for k, v in pairs(VortLeftFingerList) do
						if ragdoll:LookupBone(v) != nil then
							ragdoll:SetBoneMatrix(ragdoll:LookupBone(v), ragdoll:GetBoneMatrix(ragdoll:LookupBone("ValveBiped.hand1_L")))
						end
					end
				end
				
				if ragdoll:GetBoneName(bone) == "ValveBiped.hand1_R" then
					for k, v in pairs(VortRightFingerList) do
						if ragdoll:LookupBone(v) != nil then
							ragdoll:SetBoneMatrix(ragdoll:LookupBone(v), ragdoll:GetBoneMatrix(ragdoll:LookupBone("ValveBiped.hand1_R")))
						end
					end
				end
			end
			
			if bone == ragdoll:GetBoneCount() and ragdoll:GetNoDraw() then
				ragdoll:SetNoDraw(false)
			end

		end
	end
end