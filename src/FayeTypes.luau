export type Value = {
	__type: string;
    Set: (self: Value, Value: any,signalIsBasic: boolean?) -> any;
    Get: (self: Value) -> any;
    Add: (self: Value, Value: any,...any) -> ();
    Remove: (self: Value,Value: any) -> ();
    Initial: any;
    Value: any;
    ValueType: string;
    ReCalibrate: (self: Value, Instance: Instance?, Property: string?) -> ();
    Changed: RBXScriptSignal;
    Reset: (self: Value) -> any;
    Compare: (self: Value, Value: any) -> boolean;
    Destroy: (self: Value) -> ();
    Refresh: (self: Value) -> ();
    SetSignalEnabled: (self: Value, Enabled: boolean) -> ();
    GetItem: (self: Value,Index: any) -> any;
    ItemExists: (self: Value, Entity: any) -> boolean;
}
export type FayeInstance = {
	Props: {[any]: any}?;
	Instance: Instance, Thread: Thread?, CleanThread: Thread?,
	SetAttribute: (self: FayeInstance,Name: string,Value: any) -> FayeInstance,
	GetAttribute: (self: FayeInstance,Name: string) -> any,
	GetAttributes: (self: FayeInstance) -> {[string]: any};
	AddTag: (self: FayeInstance,Tag: string) -> FayeInstance,
	RemoveTag: (self: FayeInstance,Tag: string) -> FayeInstance,
	HasTag: (self: FayeInstance,Tag: string) -> boolean,
	GetTags: (self: FayeInstance) -> {string};
	Clone: (self: FayeInstance) -> Instance;
	Destroy: (self: FayeInstance) -> ();
	Compile: (self: FayeInstance) -> FayeInstance;
	--> new
	Remove: (self: FayeInstance, Item: any) -> ();
	Connect: (self: FayeInstance, Connection: RBXScriptSignal, Function: (...any) -> ()) -> RBXScriptConnection;
	Add: <T>(self: FayeInstance, Item: T, IsPriority: boolean?) -> T;
	ClearCache: (self: FayeInstance) -> ();
	-->
}
export type UserInputType = typeof(game:GetService("UserInputService"));

export type Animation = {
    __animId: string;
    Goal: any;
    Info: (Info | SpringInfo)?;
    Thread: Thread?;
	Destroy: (self: Animation) -> ();
	Stop: (self: Animation) -> ();
	Skip: (self: Animation) -> ();
	AlwaysFrom: any;
}
export type Info = {Time: number; EasingStyle: Enum.EasingStyle; EasingDirection: Enum.EasingDirection; RepeatCount: number; Reverse: boolean; DelayTime: number}
export type SpringInfo = {Time: number; Frequency: number; Damping: number; RepeatCount: number; Reverse: boolean; DelayTime: number}
export type Lerp = {
    To: any;
    Factor: number;
    From: any?;
    Thread: Thread?;
	Destroy: (self: Lerp) -> ();
	Stop: (self: Lerp) -> ();
	Skip: (self: Lerp) -> ();
}
export type Connection = {
    Disconnect: (self: Connection) -> ();
    Destroy: (self: Connection) -> ();
}
export type AnimationModifications = {
	FirstGoal: any;
	FirstDelayTime: number?;
	FirstInfo: (Info | SpringInfo)?;
	From: any;
	AlwaysFrom: any;
}

export type DelayValue = {
    Initial: any;
    Value: any;
    Time: number;
    DefaultTime: number;
    Get: (self: DelayValue) -> any;
	Set: (self: DelayValue, New: any) -> DelayValue;
	Add: (self: DelayValue, Amount: any) -> ();
	Remove: (self: DelayValue, Amount: any) -> ();
    Changed: RBXScriptSignal;
    SetTime: (self: DelayValue, Time: number) -> DelayValue;
	Refresh: (self: DelayValue) -> ();
    SetSignalEnabled: (self: DelayValue, Enabled: boolean) -> ();
    Sensitive: (self: DelayValue) -> DelayValue;
    ResetTime: (self: DelayValue) -> ();
    For: (self: DelayValue, Value: any, Time: number?) -> DelayValue;
    Destroy: (self: DelayValue) -> ();
};
export type SpecialThreadParams = {
	Lifetime: number;
	YieldSafe: boolean?
}
export type Delay = {
    Destroy: (self: Delay) -> ();
}
export type SpaceTask = {
    Destroy: (self: SpaceTask) -> ();
    Call: (self: SpaceTask) -> SpaceTask;
    Variables: {[any]: any};
    Parameters: {[any]: any};
    SpaceIndex: number;
    SetId: (self: SpaceTask, Id: any) -> SpaceTask;
    Connect: (self: SpaceTask, Connection: RBXScriptSignal) -> RBXScriptConnection;
    AddParameter: (self: SpaceTask, Index: any,Value: any) -> ();
}
export type Space = {
    Call: (self: Space, Id: any) -> Space;
    Add: (self: Space, Params: {[any]: any}, Thread: Thread?,NoUnpack: boolean?) -> SpaceTask;
    Remove: (self: Space, Task: SpaceTask) -> ();
    Connect: (self: Space, Connection: RBXScriptSignal,Id: any) -> RBXScriptConnection;
    Destroy: (self: Space) -> ();
}
export type LoadAnimation = {
	Play: (self: LoadAnimation) -> LoadAnimation;
	Stop: (self: LoadAnimation) -> ();
	Pause: (self: LoadAnimation) -> LoadAnimation;
	Resume: (self: LoadAnimation) -> LoadAnimation;
	Skip: (self: LoadAnimation) -> LoadAnimation;
	Destroy: (self: LoadAnimation) -> ();
	IsActive: boolean?;
}
export type YieldSafe = {
    Destroy: (self: YieldSafe) -> ();
}
export type Signal = {
    Destroy: (self: Signal) -> ();
    Call: (self: Signal, ...any) -> Signal;
    Connect: (self: Signal, Connection: RBXScriptSignal) -> Signal;
}
-- Every class Instance.new accepts, generated from the Roblox API dump
export type CreatableClassName = "Accessory"
	| "AccessoryDescription"
	| "Accoutrement"
	| "Actor"
	| "AdGui"
	| "AdPortal"
	| "AdvancedDragger"
	| "AirController"
	| "AlignOrientation"
	| "AlignPosition"
	| "AngularVelocity"
	| "Animation"
	| "AnimationConstraint"
	| "AnimationController"
	| "AnimationGraphDefinition"
	| "AnimationNodeDefinition"
	| "AnimationRigData"
	| "Animator"
	| "Annotation"
	| "ArcHandles"
	| "Atmosphere"
	| "AtmosphereSensor"
	| "Attachment"
	| "AudioAnalyzer"
	| "AudioChannelMixer"
	| "AudioChannelSplitter"
	| "AudioChorus"
	| "AudioCompressor"
	| "AudioDeviceInput"
	| "AudioDeviceOutput"
	| "AudioDistortion"
	| "AudioEcho"
	| "AudioEmitter"
	| "AudioEqualizer"
	| "AudioFader"
	| "AudioFilter"
	| "AudioFlanger"
	| "AudioGate"
	| "AudioLimiter"
	| "AudioListener"
	| "AudioPitchShifter"
	| "AudioPlayer"
	| "AudioRecorder"
	| "AudioReverb"
	| "AudioSearchParams"
	| "AudioSpeechToText"
	| "AudioTextToSpeech"
	| "AudioTremolo"
	| "AuroraScript"
	| "AvatarAbilityRules"
	| "AvatarAccessoryRules"
	| "AvatarAnimationRules"
	| "AvatarBodyRules"
	| "AvatarClothingRules"
	| "AvatarCollisionRules"
	| "AvatarRules"
	| "Backpack"
	| "BallSocketConstraint"
	| "Beam"
	| "BillboardGui"
	| "BinaryStringValue"
	| "BindableEvent"
	| "BindableFunction"
	| "BlockMesh"
	| "BloomEffect"
	| "BlurEffect"
	| "BodyAngularVelocity"
	| "BodyColors"
	| "BodyForce"
	| "BodyGyro"
	| "BodyPartDescription"
	| "BodyPosition"
	| "BodyThrust"
	| "BodyVelocity"
	| "Bone"
	| "BoolValue"
	| "BoxHandleAdornment"
	| "Breakpoint"
	| "BrickColorValue"
	| "BubbleChatMessageProperties"
	| "BuoyancySensor"
	| "Camera"
	| "CanvasGroup"
	| "CFrameValue"
	| "CharacterMesh"
	| "ChorusSoundEffect"
	| "ClickDetector"
	| "ClimbController"
	| "Clouds"
	| "Color3Value"
	| "ColorCorrectionEffect"
	| "ColorGradingEffect"
	| "CompositeValueCurve"
	| "CompressorSoundEffect"
	| "ConeHandleAdornment"
	| "Configuration"
	| "ControllerManager"
	| "ControllerPartSensor"
	| "CornerWedgePart"
	| "CurveAnimation"
	| "CustomEvent"
	| "CustomEventReceiver"
	| "CustomLog"
	| "CylinderHandleAdornment"
	| "CylinderMesh"
	| "CylindricalConstraint"
	| "DataStoreGetOptions"
	| "DataStoreIncrementOptions"
	| "DataStoreOptions"
	| "DataStoreSetOptions"
	| "DebuggerWatch"
	| "Decal"
	| "DepthOfFieldEffect"
	| "Dialog"
	| "DialogChoice"
	| "DigitsRigDescription"
	| "DistortionSoundEffect"
	| "DoubleConstrainedValue"
	| "DragDetector"
	| "Dragger"
	| "EchoSoundEffect"
	| "EqualizerSoundEffect"
	| "EulerRotationCurve"
	| "ExperienceInviteOptions"
	| "ExplorerFilter"
	| "Explosion"
	| "FaceControls"
	| "FileMesh"
	| "Fire"
	| "Flag"
	| "FlagStand"
	| "FlangeSoundEffect"
	| "FloatCurve"
	| "FloorWire"
	| "FluidForceSensor"
	| "Folder"
	| "ForceField"
	| "Frame"
	| "FunctionalTest"
	| "GeneratedFolder"
	| "GetTextBoundsParams"
	| "Glue"
	| "GroundController"
	| "GuiMain"
	| "Handles"
	| "HapticEffect"
	| "Hat"
	| "HiddenSurfaceRemovalAsset"
	| "Highlight"
	| "HingeConstraint"
	| "Hint"
	| "Hole"
	| "HopperBin"
	| "Humanoid"
	| "HumanoidController"
	| "HumanoidDescription"
	| "HumanoidRigDescription"
	| "IKControl"
	| "ImageButton"
	| "ImageHandleAdornment"
	| "ImageLabel"
	| "InputAction"
	| "InputActionLabel"
	| "InputBinding"
	| "InputContext"
	| "IntConstrainedValue"
	| "InternalSyncItem"
	| "IntersectOperation"
	| "IntValue"
	| "Keyframe"
	| "KeyframeMarker"
	| "KeyframeSequence"
	| "LinearVelocity"
	| "LineForce"
	| "LineHandleAdornment"
	| "LocalizationTable"
	| "LocalScript"
	| "MakeupDescription"
	| "ManualGlue"
	| "ManualWeld"
	| "MarkerCurve"
	| "MaterialVariant"
	| "MeshPart"
	| "Message"
	| "Model"
	| "ModuleScript"
	| "Motor"
	| "Motor6D"
	| "MotorFeature"
	| "NegateOperation"
	| "NoCollisionConstraint"
	| "Noise"
	| "NumberPose"
	| "NumberValue"
	| "ObjectValue"
	| "OperationGraph"
	| "Pants"
	| "ParabolaAdornment"
	| "Part"
	| "ParticleEmitter"
	| "PartOperation"
	| "PartOperationAsset"
	| "Path2D"
	| "Path3D"
	| "PathfindingLink"
	| "PathfindingModifier"
	| "PitchShiftSoundEffect"
	| "Plane"
	| "PlaneConstraint"
	| "Player"
	| "PluginAction"
	| "PluginCapabilities"
	| "PointLight"
	| "Pose"
	| "PrismaticConstraint"
	| "ProceduralModel"
	| "ProximityPrompt"
	| "PyramidHandleAdornment"
	| "RayValue"
	| "RealtimeMedia"
	| "ReflectionMetadata"
	| "ReflectionMetadataCallbacks"
	| "ReflectionMetadataClass"
	| "ReflectionMetadataClasses"
	| "ReflectionMetadataEnum"
	| "ReflectionMetadataEnumItem"
	| "ReflectionMetadataEnums"
	| "ReflectionMetadataEvents"
	| "ReflectionMetadataFunctions"
	| "ReflectionMetadataMember"
	| "ReflectionMetadataProperties"
	| "ReflectionMetadataYieldFunctions"
	| "RelativeGui"
	| "RemoteEvent"
	| "RemoteFunction"
	| "RenderingTest"
	| "ReverbSoundEffect"
	| "RigidConstraint"
	| "RocketPropulsion"
	| "RodConstraint"
	| "RopeConstraint"
	| "Rotate"
	| "RotateP"
	| "RotateV"
	| "RotationCurve"
	| "RTAnimationTracker"
	| "ScreenGui"
	| "Script"
	| "ScrollingFrame"
	| "Seat"
	| "SelectionBox"
	| "SelectionPartLasso"
	| "SelectionPointLasso"
	| "SelectionSphere"
	| "Shirt"
	| "ShirtGraphic"
	| "SkateboardController"
	| "SkateboardPlatform"
	| "Skin"
	| "Sky"
	| "Smoke"
	| "Snap"
	| "Sound"
	| "SoundGroup"
	| "Sparkles"
	| "SpawnLocation"
	| "SpecialMesh"
	| "SphereHandleAdornment"
	| "SpotLight"
	| "SpringConstraint"
	| "StandalonePluginScripts"
	| "StarterGear"
	| "StringValue"
	| "StudioAttachment"
	| "StudioCallout"
	| "StyleDerive"
	| "StyleLink"
	| "StyleQuery"
	| "StyleRule"
	| "StyleSheet"
	| "SunRaysEffect"
	| "SurfaceAppearance"
	| "SurfaceGui"
	| "SurfaceLight"
	| "SurfaceSelection"
	| "SwimController"
	| "Team"
	| "TeleportOptions"
	| "TerrainDetail"
	| "TerrainRegion"
	| "TextBox"
	| "TextButton"
	| "TextChannel"
	| "TextChannelWindow"
	| "TextChatCommand"
	| "TextChatMessageProperties"
	| "TextGenerator"
	| "TextLabel"
	| "Texture"
	| "Tool"
	| "Torque"
	| "TorsionSpringConstraint"
	| "TrackerStreamAnimation"
	| "Trail"
	| "TremoloSoundEffect"
	| "TrussPart"
	| "Tween"
	| "UIAspectRatioConstraint"
	| "UICorner"
	| "UIDragDetector"
	| "UIFlexItem"
	| "UIGradient"
	| "UIGridLayout"
	| "UIListLayout"
	| "UIPadding"
	| "UIPageLayout"
	| "UIScale"
	| "UIShadow"
	| "UISizeConstraint"
	| "UIStroke"
	| "UITableLayout"
	| "UITextSizeConstraint"
	| "UnionOperation"
	| "UniversalConstraint"
	| "UnreliableRemoteEvent"
	| "ValueCurve"
	| "Vector3Curve"
	| "Vector3Value"
	| "VectorForce"
	| "VehicleController"
	| "VehicleSeat"
	| "VelocityMotor"
	| "VideoDeviceInput"
	| "VideoDisplay"
	| "VideoFrame"
	| "VideoPlayer"
	| "ViewportFrame"
	| "VisualizationMode"
	| "VisualizationModeCategory"
	| "WedgePart"
	| "Weld"
	| "WeldConstraint"
	| "Wire"
	| "WireframeHandleAdornment"
	| "WorkspaceAnnotation"
	| "WorldModel"
	| "WrapDeformer"
	| "WrapLayer"
	| "WrapTarget"
	| "WrapTextureTransfer"

export type Thread = {
	Lerp: (self: Thread, To: any, Factor: number?, From: any?) -> Lerp;
	IsActive: boolean?;
	ParentThread: Thread?;
    Create: (self: Thread, ClassName: CreatableClassName | string) -> (Properties: Properties) -> FayeInstance;
    Configure: (self: Thread, Entity: any) -> (Properties: Properties) -> FayeInstance;
    Extend: (self: Thread,IsOrphan: boolean?) -> Thread;
    Destroy: (self: Thread) -> ();
    Value: (self: Thread,Initial: any) -> Value;
    Animation: (self: Thread, Goal: any, Info: (Info | SpringInfo | Value)?,Modifications: AnimationModifications?) -> Animation;
    Info: (Time: number?,EasingStyle: Enum.EasingStyle?,EasingDirection: Enum.EasingDirection?, RepeatCount: number?,Reverse: boolean?,DelayTime: number?) -> Info;
    SpringInfo: (Time: number?,Frequency: number?,Damping: number?, RepeatCount: number?,Reverse: boolean?,DelayTime: number?) -> SpringInfo;
    Connect: (self: Thread, Connection: RBXScriptSignal, func: (...any) -> ()) -> RBXScriptConnection,
    Do: (self: Thread, func : (Grab: (Value: Instance | Value) -> any,Thread: Thread, Entity: Instance?) -> ()) -> any;
    State: (self: Thread, func : (Grab: (Value: Instance | Value) -> any,Thread: Thread, Entity: Instance?) -> ()) -> any;
    Iterate: (self: Thread, Table: any,func: (Index: any,Value: any,Thread: Thread?,Entity: Instance?) -> ()) -> ();
	AdvancedIterate: (self: Thread, Table: any,func: (Index: any,Value: any,Thread: Thread?,Entity: Instance?) -> ()) -> ();
    InstancePropertySync: (self:Thread, Entity: Instance, Property: string) -> Value;
    InstanceAttributeSync: (self:Thread, Entity: Instance, Attribute: string) -> Value;
    DelayValue: (self: Thread, Value: Value?, Time: number?) -> DelayValue;
    DelayProperty: (self: Thread, Props: Properties | any,Time: number,From: Properties?) -> Delay;
    SetTo: (self: Thread, Value: Value) -> any;
    Listener: (self: Thread, Entity: any, Event: string | {string}, func: (string,...any) -> ()) -> ();
    Add: <T>(self: Thread,Entity: T, IsPriority: boolean?) -> T;
    Remove: (self: Thread,Entity: any) -> boolean?;
    Space: (self: Thread, func: (...any) -> ()) -> Space,
    YieldSafe: (self: Thread,func: (...any)-> (),DelayTime: number?) -> YieldSafe;
    Schedule: (self: Thread,Time: number?,Item: any,...any) -> any;
    Signal: (self: Thread, Connections: RBXScriptSignal | {RBXScriptSignal}, func: ((...any) -> ())?) -> Signal;
    SignalState: (self: Thread, Connections: RBXScriptSignal | {RBXScriptSignal}, func: ((...any) -> ())?) -> Signal;
	GetSignal: (self: Thread, Method: string, Index: string,RunOnInitialization: boolean?) -> ();
	Spawn: (self: Thread, func: (...any) -> (),...any) -> ();
	Defer: (self: Thread, func: (...any) -> (),...any) -> ();
	Delay: (self: Thread,time: number, func: (...any) -> (),...any) -> ();
	LoadAnimation: (self: Thread, Entity: Instance,Goals: Properties, Info: (Info | SpringInfo)?) -> LoadAnimation;
	ModifyAnimation: (Animation: {[any]: any},Modifications: AnimationModifications) -> {[any]: any};
	CloneAnimation: (self: Thread, Animation: {[any]: any},Modifications: AnimationModifications?) -> {[any]: any};
	Reactive: (self: Thread, func: (Grab: (Value: Instance | Value) -> any) -> ()) -> ();
	CloneTable: (Table: {[any]: any}, cloneFunction: ((Index: any, Value: any) -> (any, any))?) -> {[any]: any};
	Debris: (self: Thread, Item: any, Lifetime: number) -> ();
	SpecialThread: (self:Thread, func: (Thread: Thread, Entity: Instance) -> (),Params: (SpecialThreadParams | number)?) -> ();
}

export type Properties = {
	After: (Properties | (Entity: Instance) -> any)?;
	Before: (Properties | (Entity: Instance) -> any)?;
	GroupColor3: any, -- Color3 value that tints all descendant GuiObjects
	GroupTransparency: any, -- Number (0-1) that sets transparency for all descendants
	AutoLocalize: any,
	BlurRadius: any,
	Spread: any,
	BottomLeftRadius: any,
	BottomRightRadius: any,
	TopLeftRadius: any,
	TopRightRadius: any,
	SizeOffset: any,
	RootLocalizationTable: any,
	ZIndexBehavior: any,
	HorizontalFlex: any,
	VerticalFlex: any,
	Video: any,
	LayoutOrder: any,
	ClearTextOnFocus: any,
	IgnoreGuiInset: any,
	Rotation: any,
	Wraps: any,
	CellSize: any,
	Padding: any,
	CellPadding: any,
	ZIndex: any,
	PlaceholderText: any,
	AbsolutePosition: any,
	AbsoluteSize: any,
	AbsoluteContentSize: any,
	TextBounds: any,
	DisplayOrder: number?,
	FontFace: any,
	AutomaticCanvasSize: any,
	ScrollBarImageColor3: any,
	ScrollBarImageTransparency: any,
	TopImage: any,
	MidImage: any,
	BottomImage: any,
	ScrollBarThickness: any,
	TextSize: any,
	CanvasSize: any,
	CanvasPosition: any,
	HorizontalAlignment: any,
	VerticalAlignment: any,
	FillDirection: any,
	TextTransparency: any,
	TextStrokeTransparency: any,
	ClipsDescendants: any,
	SortOrder: any,
	AspectRatio: any,
	AspectType: any,
	DominantAxis: any,
	Properties: any,
	Name: any,
	Parent: any,
	Anchored: any,
	BrickColor: any,
	CanCollide: any,
	Selectable: any,
	CastShadow: any,
	Color: any,
	Material: any,
	Reflectance: number?,
	Transparency: any,
	Thickness: any,
	Shape: any, -- Specific to parts like Part, Ball, Cylinder
	RichText: any,
	-- BasePart Events
	
	--<new stroke properties
               -- UIStroke.Thickness (pixels when FixedSize)
ApplyStrokeMode: any,          -- Enum.ApplyStrokeMode
BorderStrokePosition: any,-- Enum.BorderStrokePosition (Inner/Center/Outer)
BorderOffset: any,                -- UIStroke.BorderOffset (UDim)
LineJoinMode: any,   -- Enum.LineJoinMode (Round/Bevel/Miter)
StrokeSizingMode: any, -- Enum.StrokeSizingMode (FixedSize / maybe UDim variants)
TextWrap: any,
	-- >
	AutomaticSize: any;

	CursorPosition: any;
	MultiLine: any;
	PlaceholderColor3: any;
	Focused: any, -- Fired when the TextBox gains focus
	FocusLost: any, -- Fired when the TextBox loses focus
	ReturnPressedFromOnScreenKeyboard: any, -- Mobile only
	Interactable: any,
	TextEditable: any,
	--< UI Flex Item
	FlexMode: any,
	GrowRatio: any,
	ShrinkRatio: any,
	ItemAlignment: any,
	-->
ResetOnSpawn: any;
	--Viewport frame
	Ambient: any,
	LightColor: any,
	LightDirection: any,
	CurrentCamera: any,
	Focus: any,

	CleanDelay: any,
	CleanFunction: (((Thread: Thread, Entity: Instance) -> Properties?) | Properties)?,
	OnClean: (((Thread: Thread, entity: Instance) -> Properties?) | Properties)?, -- replaces clean function
	-- Generic Instance Properties
	Archivable: any,

	-- Model Properties
	PrimaryPart: any,
	WorldPivot: any,

	-- Camera Properties
	CameraType: any,
	CFrame: any,
	FieldOfView: any,
	TextWrapped: any,
	TextXAlignment: any,
	TextYAlignment: any,
	-- UI Element Properties (TextLabel, TextButton, ImageLabel, ImageButton, etc.)
	Text: any,
	TextColor3: any,
	Font: any,
	TextScaled: any,
	BackgroundColor3: any,
	BackgroundTransparency: any,
	BorderColor3: any,
	BorderSizePixel: any,
	Size: any,
	Position: any,
	AnchorPoint: any,
	Visible: any,
	Image: any, -- For ImageLabel and ImageButton
	ImageColor3: any,
	ImageTransparency: any,
	ScaleType: any,
	SliceCenter: any,
	AutoButtonColor: any, -- For TextButton and ImageButton

	-- UI Events (TextLabel, TextButton, ImageLabel, ImageButton, etc.)
	MouseEnter: (Entity: Instance, ...any) -> ()?, -- Triggered when the mouse enters the UI element
	MouseLeave: (Entity: Instance, ...any) -> ()?, -- Triggered when the mouse leaves the UI element
	MouseMoved: (Entity: Instance, ...any) -> ()?, -- Triggered when the mouse moves over the element
	MouseWheelForward: (Entity: Instance, ...any) -> ()?, -- Triggered when the mouse wheel scrolls forward
	MouseWheelBackward: (Entity: Instance, ...any) -> ()?, -- Triggered when the mouse wheel scrolls backward
	InputBegan: (Entity: Instance, ...any) -> ()?, -- Triggered when an input begins (e.g., key press)
	InputEnded: (Entity: Instance, ...any) -> ()?, -- Triggered when an input ends (e.g., key release)
	InputChanged: (Entity: Instance, ...any) -> ()?, -- Triggered when an input changes (e.g., mouse move)
	MouseButton1Click: (Entity: Instance, ...any) -> ()?, -- Triggered when the left mouse button is clicked
	MouseButton2Click: (Entity: Instance, ...any) -> ()?, -- Triggered when the right mouse button is clicked
	MouseButton1Down: (Entity: Instance, ...any) -> ()?, -- Triggered when the left mouse button is pressed down
	MouseButton1Up: (Entity: Instance, ...any) -> ()?, -- Triggered when the left mouse button is released
	MouseButton2Down: (Entity: Instance, ...any) -> ()?, -- Triggered when the right mouse button is pressed down
	MouseButton2Up: (Entity: Instance, ...any) -> ()?, -- Triggered when the right mouse button is released
	Offset: any,
	TileSize: any,
	TextStrokeColor3: any,
	-- BillboardGui Properties
	Adornee: any,
	StudsOffset: any,
	MaxDistance: any,
	ExtentsOffset: any,
	AlwaysOnTop: any,
	Active: any,
	-- UICorner
	CornerRadius: any,

	-- BillboardGui Events
	AdorneeChanged: (Entity: Instance, ...any) -> ()?, -- Triggered when the Adornee property changes

	-- Tool Properties
	RequiresHandle: any,
	Grip: any,
	Enabled: any,

	-- Tool Events
	Activated: (Entity: Instance, ...any) -> ()?, -- Triggered when the tool is activated
	Deactivated: (Entity: Instance, ...any) -> ()?, -- Triggered when the tool is deactivated
	Equipped: (Entity: Instance, ...any) -> ()?, -- Triggered when the tool is equipped
	Unequipped: (Entity: Instance, ...any) -> ()?, -- Triggered when the tool is unequipped

	-- Sound Properties
	SoundId: any,
	Volume: any,
	PlaybackSpeed: any,
	TimePosition: any,
	Looping: any,
	Playing: any,
	RollOffMode: any,
	MinDistance: any,

	-- Sound Events
	Played: (Entity: Instance, ...any) -> ()?, -- Triggered when the sound starts playing
	Stopped: (Entity: Instance, ...any) -> ()?, -- Triggered when the sound stops
	Ended: (Entity: Instance, ...any) -> ()?, -- Triggered when the sound finishes playing
	Looped: (Entity: Instance, ...any) -> ()?, -- Triggered when the sound loops

	-- Animation Properties
	AnimationId: any,

	-- Animation Events
	KeyframeReached: (Entity: Instance, ...any) -> ()?, -- Triggered when a specific keyframe is reached
	-- part events
	TagAdded: (Entity: Instance, ...any) -> ()?,
	TagRemoved: (Entity: Instance, ...any) -> ()?,

	-- Highlight Properties
	DepthMode: any,
	FillColor: any,
	FillTransparency: any,
	OutlineColor: any,
	OutlineTransparency: any,
}
return nil;