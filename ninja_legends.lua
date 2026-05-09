\--\[\[

&#x09;WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!

]]

\--\[\[

&#x09;WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!

]]

local Players = game:GetService("Players")

local player = Players.LocalPlayer

local library = {count = 0, queue = {}, callbacks = {}, rainbowtable = {}, toggled = true, binds = {}};

local defaults; do

&#x20;   local dragger = {}; do

&#x20;       local mouse        = game:GetService("Players").LocalPlayer:GetMouse();

&#x20;       local inputService = game:GetService('UserInputService');

&#x20;       local heartbeat    = game:GetService("RunService").Heartbeat;

&#x20;       -- // credits to Ririchi / Inori for this cute drag function :)

&#x20;       function dragger.new(frame)

&#x20;           local s, event = pcall(function()

&#x20;               return frame.MouseEnter

&#x20;           end)

&#x20;

&#x20;           if s then

&#x20;               frame.Active = true;

&#x20;

&#x20;               event:connect(function()

&#x20;                   local input = frame.InputBegan:connect(function(key)

&#x20;                       if key.UserInputType == Enum.UserInputType.MouseButton1 then

&#x20;                           local objectPosition = Vector2.new(mouse.X - frame.AbsolutePosition.X, mouse.Y - frame.AbsolutePosition.Y);

&#x20;                           while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do

&#x20;                               pcall(function()

&#x20;                                   frame:TweenPosition(UDim2.new(0, mouse.X - objectPosition.X + (frame.Size.X.Offset \* frame.AnchorPoint.X), 0, mouse.Y - objectPosition.Y + (frame.Size.Y.Offset \* frame.AnchorPoint.Y)), 'Out', 'Linear', 0.1, true);

&#x20;                               end)

&#x20;                           end

&#x20;                       end

&#x20;                   end)

&#x20;

&#x20;                   local leave;

&#x20;                   leave = frame.MouseLeave:connect(function()

&#x20;                       input:disconnect();

&#x20;                       leave:disconnect();

&#x20;                   end)

&#x20;               end)

&#x20;           end

&#x20;       end

&#x20;

&#x20;       game:GetService('UserInputService').InputBegan:connect(function(key, gpe)

&#x20;           if (not gpe) then

&#x20;               if key.KeyCode == Enum.KeyCode.F15 then

&#x20;                   library.toggled = not library.toggled;

&#x20;                   for i, data in next, library.queue do

local pos = (library.toggled and data.p or UDim2.new(-1, 0, -0.5,0))

data.w:TweenPosition(pos, (library.toggled and 'Out' or 'In'), 'Quad', 0.15, true)

&#x20;                       wait();

&#x20;                   end

&#x20;               end

&#x20;           end

&#x20;       end)

&#x20;   end

&#x20;

&#x20;   local types = {}; do

&#x20;       types.\_\_index = types;

&#x20;       function types.window(name, options)

&#x20;           library.count = library.count + 1

&#x20;           local newWindow = library:Create('Frame', {

&#x20;               Name = name;

&#x20;               Size = UDim2.new(0, 190, 0, 30);

&#x20;               BackgroundColor3 = options.topcolor;

&#x20;               BorderSizePixel = 0;

&#x20;               Parent = library.container;

&#x20;               Position = UDim2.new(0, (15 + (200 \* library.count) - 200), 0, 0);

&#x20;               ZIndex = 3;

&#x20;               library:Create('TextLabel', {

&#x20;                   Text = name;

&#x20;                   Size = UDim2.new(1, -10, 1, 0);

&#x20;                   Position = UDim2.new(0, 5, 0, 0);

&#x20;                   BackgroundTransparency = 1;

&#x20;                   Font = Enum.Font.Code;

&#x20;                   TextSize = options.titlesize;

&#x20;                   Font = options.titlefont;

&#x20;                   TextColor3 = options.titletextcolor;

&#x20;                   TextStrokeTransparency = library.options.titlestroke;

&#x20;                   TextStrokeColor3 = library.options.titlestrokecolor;

&#x20;                   ZIndex = 3;

&#x20;               });

&#x20;               library:Create("TextButton", {

&#x20;                   Size = UDim2.new(0, 30, 0, 30);

&#x20;                   Position = UDim2.new(1, -35, 0, 0);

&#x20;                   BackgroundTransparency = 1;

&#x20;                   Text = "-";

&#x20;                   TextSize = options.titlesize;

&#x20;                   Font = options.titlefont;--Enum.Font.Code;

&#x20;                   Name = 'window\_toggle';

&#x20;                   TextColor3 = options.titletextcolor;

&#x20;                   TextStrokeTransparency = library.options.titlestroke;

&#x20;                   TextStrokeColor3 = library.options.titlestrokecolor;

&#x20;                   ZIndex = 3;

&#x20;               });

&#x20;               library:Create("Frame", {

&#x20;                   Name = 'Underline';

&#x20;                   Size = UDim2.new(1, 0, 0, 2);

&#x20;                   Position = UDim2.new(0, 0, 1, -2);

&#x20;                   BackgroundColor3 = (options.underlinecolor \~= "rainbow" and options.underlinecolor or Color3.new());

&#x20;                   BorderSizePixel = 0;

&#x20;                   ZIndex = 3;

&#x20;               });

&#x20;               library:Create('Frame', {

&#x20;                   Name = 'container';

&#x20;                   Position = UDim2.new(0, 0, 1, 0);

&#x20;                   Size = UDim2.new(1, 0, 0, 0);

&#x20;                   BorderSizePixel = 0;

&#x20;                   BackgroundColor3 = options.bgcolor;

&#x20;                   ClipsDescendants = false;

&#x20;                   library:Create('UIListLayout', {

&#x20;                       Name = 'List';

&#x20;                       SortOrder = Enum.SortOrder.LayoutOrder;

&#x20;                   })

&#x20;               });

&#x20;           })

&#x20;

&#x20;           if options.underlinecolor == "rainbow" then

&#x20;               table.insert(library.rainbowtable, newWindow:FindFirstChild('Underline'))

&#x20;           end

&#x20;

&#x20;           local window = setmetatable({

&#x20;               count = 0;

&#x20;               object = newWindow;

&#x20;               container = newWindow.container;

&#x20;               toggled = true;

&#x20;               flags   = {};

&#x20;

&#x20;           }, types)

&#x20;

&#x20;           table.insert(library.queue, {

&#x20;               w = window.object;

&#x20;               p = window.object.Position;

&#x20;           })

&#x20;

&#x20;           newWindow:FindFirstChild("window\_toggle").MouseButton1Click:connect(function()

&#x20;               window.toggled = not window.toggled;

&#x20;               newWindow:FindFirstChild("window\_toggle").Text = (window.toggled and "+" or "-")

&#x20;               if (not window.toggled) then

&#x20;                   window.container.ClipsDescendants = true;

&#x20;               end

&#x20;               wait();

&#x20;               local y = 0;

&#x20;               for i, v in next, window.container:GetChildren() do

&#x20;                   if (not v:IsA('UIListLayout')) then

&#x20;                       y = y + v.AbsoluteSize.Y;

&#x20;                   end

&#x20;               end

&#x20;

&#x20;               local targetSize = window.toggled and UDim2.new(1, 0, 0, y+5) or UDim2.new(1, 0, 0, 0);

&#x20;               local targetDirection = window.toggled and "In" or "Out"

&#x20;

&#x20;               window.container:TweenSize(targetSize, targetDirection, "Quad", 0.15, true)

&#x20;               wait(.15)

&#x20;               if window.toggled then

&#x20;                   window.container.ClipsDescendants = false;

&#x20;               end

&#x20;           end)

&#x20;

&#x20;           return window;

&#x20;       end

&#x20;

&#x20;       function types:Resize()

&#x20;           local y = 0;

&#x20;           for i, v in next, self.container:GetChildren() do

&#x20;               if (not v:IsA('UIListLayout')) then

&#x20;                   y = y + v.AbsoluteSize.Y;

&#x20;               end

&#x20;           end

&#x20;           self.container.Size = UDim2.new(1, 0, 0, y+5)

&#x20;       end

&#x20;

&#x20;       function types:GetOrder()

&#x20;           local c = 0;

&#x20;           for i, v in next, self.container:GetChildren() do

&#x20;               if (not v:IsA('UIListLayout')) then

&#x20;                   c = c + 1

&#x20;               end

&#x20;           end

&#x20;           return c

&#x20;       end

&#x20;

&#x20;       function types:Label(text)

&#x20;           local v = game:GetService'TextService':GetTextSize(text, 18, Enum.Font.SourceSans, Vector2.new(math.huge, math.huge))

&#x20;           local object = library:Create('Frame', {

&#x20;               Size = UDim2.new(1, 0, 0, v.Y + 5);

&#x20;               BackgroundTransparency  = 1;

&#x20;               library:Create('TextLabel', {

&#x20;                   Size = UDim2.new(1, 0, 1, 0);

&#x20;                   Position = UDim2.new(0, 10, 0, 0);

&#x20;                   LayoutOrder = self:GetOrder();

&#x20;

&#x20;                   Text = text;

&#x20;                   TextSize = 18;

&#x20;                   Font = Enum.Font.SourceSans;

&#x20;                   TextColor3 = Color3.fromRGB(255, 255, 255);

&#x20;                   BackgroundTransparency = 1;

&#x20;                   TextXAlignment = Enum.TextXAlignment.Left;

&#x20;                   TextWrapped = true;

&#x20;               });

&#x20;               Parent = self.container

&#x20;           })

&#x20;           self:Resize();

&#x20;       end

&#x20;

&#x20;       function types:Toggle(name, options, callback)

&#x20;           local default  = options.default or false;

&#x20;           local location = options.location or self.flags;

&#x20;           local flag     = options.flag or "";

&#x20;           local callback = callback or function() end;

&#x20;

&#x20;           location\[flag] = default;

&#x20;

&#x20;           local check = library:Create('Frame', {

&#x20;               BackgroundTransparency = 1;

&#x20;               Size = UDim2.new(1, 0, 0, 25);

&#x20;               LayoutOrder = self:GetOrder();

&#x20;               library:Create('TextLabel', {

&#x20;                   Name = name;

&#x20;                   Text = "\\r" .. name;

&#x20;                   BackgroundTransparency = 1;

&#x20;                   TextColor3 = library.options.textcolor;

&#x20;                   Position = UDim2.new(0, 5, 0, 0);

&#x20;                   Size     = UDim2.new(1, -5, 1, 0);

&#x20;                   TextXAlignment = Enum.TextXAlignment.Left;

&#x20;                   Font = library.options.font;

&#x20;                   TextSize = library.options.fontsize;

&#x20;                   TextStrokeTransparency = library.options.textstroke;

&#x20;                   TextStrokeColor3 = library.options.strokecolor;

&#x20;                   library:Create('TextButton', {

&#x20;                       Text = (location\[flag] and utf8.char(10003) or "");

&#x20;                       Font = library.options.font;

&#x20;                       TextSize = library.options.fontsize;

&#x20;                       Name = 'Checkmark';

&#x20;                       Size = UDim2.new(0, 20, 0, 20);

&#x20;                       Position = UDim2.new(1, -25, 0, 4);

&#x20;                       TextColor3 = library.options.textcolor;

&#x20;                       BackgroundColor3 = library.options.bgcolor;

&#x20;                       BorderColor3 = library.options.bordercolor;

&#x20;                       TextStrokeTransparency = library.options.textstroke;

&#x20;                       TextStrokeColor3 = library.options.strokecolor;

&#x20;                   })

&#x20;               });

&#x20;               Parent = self.container;

&#x20;           });

&#x20;

&#x20;           local function click(t)

&#x20;               location\[flag] = not location\[flag];

&#x20;               callback(location\[flag])

&#x20;               check:FindFirstChild(name).Checkmark.Text = location\[flag] and utf8.char(10003) or "";

&#x20;           end

&#x20;

&#x20;           check:FindFirstChild(name).Checkmark.MouseButton1Click:connect(click)

&#x20;           library.callbacks\[flag] = click;

&#x20;

&#x20;           if location\[flag] == true then

&#x20;               callback(location\[flag])

&#x20;           end

&#x20;

&#x20;           self:Resize();

&#x20;           return {

&#x20;               Set = function(self, b)

&#x20;                   location\[flag] = b;

&#x20;                   callback(location\[flag])

&#x20;                   check:FindFirstChild(name).Checkmark.Text = location\[flag] and utf8.char(10003) or "";

&#x20;               end

&#x20;           }

&#x20;       end

&#x20;

&#x20;       function types:Button(name, callback)

&#x20;           callback = callback or function() end;

&#x20;

&#x20;           local check = library:Create('Frame', {

&#x20;               BackgroundTransparency = 1;

&#x20;               Size = UDim2.new(1, 0, 0, 25);

&#x20;               LayoutOrder = self:GetOrder();

&#x20;               library:Create('TextButton', {

&#x20;                   Name = name;

&#x20;                   Text = name;

&#x20;                   BackgroundColor3 = library.options.btncolor;

&#x20;                   BorderColor3 = library.options.bordercolor;

&#x20;                   TextStrokeTransparency = library.options.textstroke;

&#x20;                   TextStrokeColor3 = library.options.strokecolor;

&#x20;                   TextColor3 = library.options.textcolor;

&#x20;                   Position = UDim2.new(0, 5, 0, 5);

&#x20;                   Size     = UDim2.new(1, -10, 0, 20);

&#x20;                   Font = library.options.font;

&#x20;                   TextSize = library.options.fontsize;

&#x20;               });

&#x20;               Parent = self.container;

&#x20;           });

&#x20;

&#x20;           check:FindFirstChild(name).MouseButton1Click:connect(callback)

&#x20;           self:Resize();

&#x20;

&#x20;           return {

&#x20;               Fire = function()

&#x20;                   callback();

&#x20;               end

&#x20;           }

&#x20;       end

&#x20;

&#x20;       function types:Box(name, options, callback) --type, default, data, location, flag)

&#x20;           local type   = options.type or "";

&#x20;           local default = options.default or "";

&#x20;           local data = options.data

&#x20;           local location = options.location or self.flags;

&#x20;           local flag     = options.flag or "";

&#x20;           local callback = callback or function() end;

&#x20;           local min      = options.min or 0;

&#x20;           local max      = options.max or 9e9;

&#x20;

&#x20;           if type == 'number' and (not tonumber(default)) then

&#x20;               location\[flag] = default;

&#x20;           else

&#x20;               location\[flag] = "";

&#x20;               default = "";

&#x20;           end

&#x20;

&#x20;           local check = library:Create('Frame', {

&#x20;               BackgroundTransparency = 1;

&#x20;               Size = UDim2.new(1, 0, 0, 25);

&#x20;               LayoutOrder = self:GetOrder();

&#x20;               library:Create('TextLabel', {

&#x20;                   Name = name;

&#x20;                   Text = "\\r" .. name;

&#x20;                   BackgroundTransparency = 1;

&#x20;                   TextColor3 = library.options.textcolor;

&#x20;                   TextStrokeTransparency = library.options.textstroke;

&#x20;                   TextStrokeColor3 = library.options.strokecolor;

&#x20;                   Position = UDim2.new(0, 5, 0, 0);

&#x20;                   Size     = UDim2.new(1, -5, 1, 0);

&#x20;                   TextXAlignment = Enum.TextXAlignment.Left;

&#x20;                   Font = library.options.font;

&#x20;                   TextSize = library.options.fontsize;

&#x20;                   library:Create('TextBox', {

&#x20;                       TextStrokeTransparency = library.options.textstroke;

&#x20;                       TextStrokeColor3 = library.options.strokecolor;

&#x20;                       Text = tostring(default);

&#x20;                       Font = library.options.font;

&#x20;                       TextSize = library.options.fontsize;

&#x20;                       Name = 'Box';

&#x20;                       Size = UDim2.new(0, 60, 0, 20);

&#x20;                       Position = UDim2.new(1, -65, 0, 3);

&#x20;                       TextColor3 = library.options.textcolor;

&#x20;                       BackgroundColor3 = library.options.boxcolor;

&#x20;                       BorderColor3 = library.options.bordercolor;

&#x20;                       PlaceholderColor3 = library.options.placeholdercolor;

&#x20;                   })

&#x20;               });

&#x20;               Parent = self.container;

&#x20;           });

&#x20;

&#x20;           local box = check:FindFirstChild(name):FindFirstChild('Box');

&#x20;           box.FocusLost:connect(function(e)

&#x20;               local old = location\[flag];

&#x20;               if type == "number" then

&#x20;                   local num = tonumber(box.Text)

&#x20;                   if (not num) then

&#x20;                       box.Text = tonumber(location\[flag])

&#x20;                   else

&#x20;                       location\[flag] = math.clamp(num, min, max)

&#x20;                       box.Text = tonumber(location\[flag])

&#x20;                   end

&#x20;               else

&#x20;                   location\[flag] = tostring(box.Text)

&#x20;               end

&#x20;

&#x20;               callback(location\[flag], old, e)

&#x20;           end)

&#x20;

&#x20;           if type == 'number' then

&#x20;               box:GetPropertyChangedSignal('Text'):connect(function()

&#x20;                   box.Text = string.gsub(box.Text, "\[%a+]", "");

&#x20;               end)

&#x20;           end

&#x20;

&#x20;           self:Resize();

&#x20;           return box

&#x20;       end

&#x20;

&#x20;       function types:Bind(name, options, callback)

&#x20;           local location     = options.location or self.flags;

&#x20;           local keyboardOnly = options.kbonly or false

&#x20;           local flag         = options.flag or "";

&#x20;           local callback     = callback or function() end;

&#x20;           local default      = options.default;

&#x20;

&#x20;           if keyboardOnly and (not tostring(default):find('MouseButton')) then

&#x20;               location\[flag] = default

&#x20;           end

&#x20;

&#x20;           local banned = {

&#x20;               Return = true;

&#x20;               Space = true;

&#x20;               Tab = true;

&#x20;               Unknown = true;

&#x20;           }

&#x20;

&#x20;           local shortNames = {

&#x20;               RightControl = 'RightCtrl';

&#x20;               LeftControl = 'LeftCtrl';

&#x20;               LeftShift = 'LShift';

&#x20;               RightShift = 'RShift';

&#x20;               MouseButton1 = "Mouse1";

&#x20;               MouseButton2 = "Mouse2";

&#x20;           }

&#x20;

&#x20;           local allowed = {

&#x20;               MouseButton1 = true;

&#x20;               MouseButton2 = true;

&#x20;           }

&#x20;

&#x20;           local nm = (default and (shortNames\[default.Name] or default.Name) or "None");

&#x20;           local check = library:Create('Frame', {

&#x20;               BackgroundTransparency = 1;

&#x20;               Size = UDim2.new(1, 0, 0, 30);

&#x20;               LayoutOrder = self:GetOrder();

&#x20;               library:Create('TextLabel', {

&#x20;                   Name = name;

&#x20;                   Text = "\\r" .. name;

&#x20;                   BackgroundTransparency = 1;

&#x20;                   TextColor3 = library.options.textcolor;

&#x20;                   Position = UDim2.new(0, 5, 0, 0);

&#x20;                   Size     = UDim2.new(1, -5, 1, 0);

&#x20;                   TextXAlignment = Enum.TextXAlignment.Left;

&#x20;                   Font = library.options.font;

&#x20;                   TextSize = library.options.fontsize;

&#x20;                   TextStrokeTransparency = library.options.textstroke;

&#x20;                   TextStrokeColor3 = library.options.strokecolor;

&#x20;                   BorderColor3     = library.options.bordercolor;

&#x20;                   BorderSizePixel  = 1;

&#x20;                   library:Create('TextButton', {

&#x20;                       Name = 'Keybind';

&#x20;                       Text = nm;

&#x20;                       TextStrokeTransparency = library.options.textstroke;

&#x20;                       TextStrokeColor3 = library.options.strokecolor;

&#x20;                       Font = library.options.font;

&#x20;                       TextSize = library.options.fontsize;

&#x20;                       Size = UDim2.new(0, 60, 0, 20);

&#x20;                       Position = UDim2.new(1, -65, 0, 5);

&#x20;                       TextColor3 = library.options.textcolor;

&#x20;                       BackgroundColor3 = library.options.bgcolor;

&#x20;                       BorderColor3     = library.options.bordercolor;

&#x20;                       BorderSizePixel  = 1;

&#x20;                   })

&#x20;               });

&#x20;               Parent = self.container;

&#x20;           });

&#x20;

&#x20;           local button = check:FindFirstChild(name).Keybind;

&#x20;           button.MouseButton1Click:connect(function()

&#x20;               library.binding = true

&#x20;

&#x20;               button.Text = "..."

&#x20;               local a, b = game:GetService('UserInputService').InputBegan:wait();

&#x20;               local name = tostring(a.KeyCode.Name);

&#x20;               local typeName = tostring(a.UserInputType.Name);

&#x20;

&#x20;               if (a.UserInputType \~= Enum.UserInputType.Keyboard and (allowed\[a.UserInputType.Name]) and (not keyboardOnly)) or (a.KeyCode and (not banned\[a.KeyCode.Name])) then

&#x20;                   local name = (a.UserInputType \~= Enum.UserInputType.Keyboard and a.UserInputType.Name or a.KeyCode.Name);

&#x20;                   location\[flag] = (a);

&#x20;                   button.Text = shortNames\[name] or name;

&#x20;

&#x20;               else

&#x20;                   if (location\[flag]) then

&#x20;                       if (not pcall(function()

&#x20;                           return location\[flag].UserInputType

&#x20;                       end)) then

&#x20;                           local name = tostring(location\[flag])

&#x20;                           button.Text = shortNames\[name] or name

&#x20;                       else

&#x20;                           local name = (location\[flag].UserInputType \~= Enum.UserInputType.Keyboard and location\[flag].UserInputType.Name or location\[flag].KeyCode.Name);

&#x20;                           button.Text = shortNames\[name] or name;

&#x20;                       end

&#x20;                   end

&#x20;               end

&#x20;

&#x20;               wait(0.1)

&#x20;               library.binding = false;

&#x20;           end)

&#x20;

&#x20;           if location\[flag] then

&#x20;               button.Text = shortNames\[tostring(location\[flag].Name)] or tostring(location\[flag].Name)

&#x20;           end

&#x20;

&#x20;           library.binds\[flag] = {

&#x20;               location = location;

&#x20;               callback = callback;

&#x20;           };

&#x20;

&#x20;           self:Resize();

&#x20;       end

&#x20;

&#x20;       function types:Section(name)

&#x20;           local order = self:GetOrder();

&#x20;           local determinedSize = UDim2.new(1, 0, 0, 25)

&#x20;           local determinedPos = UDim2.new(0, 0, 0, 4);

&#x20;           local secondarySize = UDim2.new(1, 0, 0, 20);

&#x20;

&#x20;           if order == 0 then

&#x20;               determinedSize = UDim2.new(1, 0, 0, 21)

&#x20;               determinedPos = UDim2.new(0, 0, 0, -1);

&#x20;               secondarySize = nil

&#x20;           end

&#x20;

&#x20;           local check = library:Create('Frame', {

&#x20;               Name = 'Section';

&#x20;               BackgroundTransparency = 1;

&#x20;               Size = determinedSize;

&#x20;               BackgroundColor3 = library.options.sectncolor;

&#x20;               BorderSizePixel = 0;

&#x20;               LayoutOrder = order;

&#x20;               library:Create('TextLabel', {

&#x20;                   Name = 'section\_lbl';

&#x20;                   Text = name;

&#x20;                   BackgroundTransparency = 0;

&#x20;                   BorderSizePixel = 0;

&#x20;                   BackgroundColor3 = library.options.sectncolor;

&#x20;                   TextColor3 = library.options.textcolor;

&#x20;                   Position = determinedPos;

&#x20;                   Size     = (secondarySize or UDim2.new(1, 0, 1, 0));

&#x20;                   Font = library.options.font;

&#x20;                   TextSize = library.options.fontsize;

&#x20;                   TextStrokeTransparency = library.options.textstroke;

&#x20;                   TextStrokeColor3 = library.options.strokecolor;

&#x20;               });

&#x20;               Parent = self.container;

&#x20;           });

&#x20;

&#x20;           self:Resize();

&#x20;       end

&#x20;

&#x20;       function types:Slider(name, options, callback)

&#x20;           local default = options.default or options.min;

&#x20;           local min     = options.min or 0;

&#x20;           local max      = options.max or 1;

&#x20;           local location = options.location or self.flags;

&#x20;           local precise  = options.precise  or false -- e.g 0, 1 vs 0, 0.1, 0.2, ...

&#x20;           local flag     = options.flag or "";

&#x20;           local callback = callback or function() end

&#x20;

&#x20;           location\[flag] = default;

&#x20;

&#x20;           local check = library:Create('Frame', {

&#x20;               BackgroundTransparency = 1;

&#x20;               Size = UDim2.new(1, 0, 0, 25);

&#x20;               LayoutOrder = self:GetOrder();

&#x20;               library:Create('TextLabel', {

&#x20;                   Name = name;

&#x20;                   TextStrokeTransparency = library.options.textstroke;

&#x20;                   TextStrokeColor3 = library.options.strokecolor;

&#x20;                   Text = "\\r" .. name;

&#x20;                   BackgroundTransparency = 1;

&#x20;                   TextColor3 = library.options.textcolor;

&#x20;                   Position = UDim2.new(0, 5, 0, 2);

&#x20;                   Size     = UDim2.new(1, -5, 1, 0);

&#x20;                   TextXAlignment = Enum.TextXAlignment.Left;

&#x20;                   Font = library.options.font;

&#x20;                   TextSize = library.options.fontsize;

&#x20;                   library:Create('Frame', {

&#x20;                       Name = 'Container';

&#x20;                       Size = UDim2.new(0, 60, 0, 20);

&#x20;                       Position = UDim2.new(1, -65, 0, 3);

&#x20;                       BackgroundTransparency = 1;

&#x20;                       --BorderColor3 = library.options.bordercolor;

&#x20;                       BorderSizePixel = 0;

&#x20;                       library:Create('TextLabel', {

&#x20;                           Name = 'ValueLabel';

&#x20;                           Text = default;

&#x20;                           BackgroundTransparency = 1;

&#x20;                           TextColor3 = library.options.textcolor;

&#x20;                           Position = UDim2.new(0, -10, 0, 0);

&#x20;                           Size     = UDim2.new(0, 1, 1, 0);

&#x20;                           TextXAlignment = Enum.TextXAlignment.Right;

&#x20;                           Font = library.options.font;

&#x20;                           TextSize = library.options.fontsize;

&#x20;                           TextStrokeTransparency = library.options.textstroke;

&#x20;                           TextStrokeColor3 = library.options.strokecolor;

&#x20;                       });

&#x20;                       library:Create('TextButton', {

&#x20;                           Name = 'Button';

&#x20;                           Size = UDim2.new(0, 5, 1, -2);

&#x20;                           Position = UDim2.new(0, 0, 0, 1);

&#x20;                           AutoButtonColor = false;

&#x20;                           Text = "";

&#x20;                           BackgroundColor3 = Color3.fromRGB(20, 20, 20);

&#x20;                           BorderSizePixel = 0;

&#x20;                           ZIndex = 2;

&#x20;                           TextStrokeTransparency = library.options.textstroke;

&#x20;                           TextStrokeColor3 = library.options.strokecolor;

&#x20;                       });

&#x20;                       library:Create('Frame', {

&#x20;                           Name = 'Line';

&#x20;                           BackgroundTransparency = 0;

&#x20;                           Position = UDim2.new(0, 0, 0.5, 0);

&#x20;                           Size     = UDim2.new(1, 0, 0, 1);

&#x20;                           BackgroundColor3 = Color3.fromRGB(255, 255, 255);

&#x20;                           BorderSizePixel = 0;

&#x20;                       });

&#x20;                   })

&#x20;               });

&#x20;               Parent = self.container;

&#x20;           });

&#x20;

&#x20;           local overlay = check:FindFirstChild(name);

&#x20;

&#x20;           local renderSteppedConnection;

&#x20;           local inputBeganConnection;

&#x20;           local inputEndedConnection;

&#x20;           local mouseLeaveConnection;

&#x20;           local mouseDownConnection;

&#x20;           local mouseUpConnection;

&#x20;

&#x20;           check:FindFirstChild(name).Container.MouseEnter:connect(function()

&#x20;               local function update()

&#x20;                   if renderSteppedConnection then renderSteppedConnection:disconnect() end

&#x20;

&#x20;

&#x20;                   renderSteppedConnection = game:GetService('RunService').RenderStepped:connect(function()

&#x20;                       local mouse = game:GetService("UserInputService"):GetMouseLocation()

&#x20;                       local percent = (mouse.X - overlay.Container.AbsolutePosition.X) / (overlay.Container.AbsoluteSize.X)

&#x20;                       percent = math.clamp(percent, 0, 1)

&#x20;                       percent = tonumber(string.format("%.2f", percent))

&#x20;

&#x20;                       overlay.Container.Button.Position = UDim2.new(math.clamp(percent, 0, 0.99), 0, 0, 1)

&#x20;

&#x20;                       local num = min + (max - min) \* percent

&#x20;                       local value = (precise and num or math.floor(num))

&#x20;

&#x20;                       overlay.Container.ValueLabel.Text = value;

&#x20;                       callback(tonumber(value))

&#x20;                       location\[flag] = tonumber(value)

&#x20;                   end)

&#x20;               end

&#x20;

&#x20;               local function disconnect()

&#x20;                   if renderSteppedConnection then renderSteppedConnection:disconnect() end

&#x20;                   if inputBeganConnection then inputBeganConnection:disconnect() end

&#x20;                   if inputEndedConnection then inputEndedConnection:disconnect() end

&#x20;                   if mouseLeaveConnection then mouseLeaveConnection:disconnect() end

&#x20;                   if mouseUpConnection then mouseUpConnection:disconnect() end

&#x20;               end

&#x20;

&#x20;               inputBeganConnection = check:FindFirstChild(name).Container.InputBegan:connect(function(input)

&#x20;                   if input.UserInputType == Enum.UserInputType.MouseButton1 then

&#x20;                       update()

&#x20;                   end

&#x20;               end)

&#x20;

&#x20;               inputEndedConnection = check:FindFirstChild(name).Container.InputEnded:connect(function(input)

&#x20;                   if input.UserInputType == Enum.UserInputType.MouseButton1 then

&#x20;                       disconnect()

&#x20;                   end

&#x20;               end)

&#x20;

&#x20;               mouseDownConnection = check:FindFirstChild(name).Container.Button.MouseButton1Down:connect(update)

&#x20;               mouseUpConnection   = game:GetService("UserInputService").InputEnded:connect(function(a, b)

&#x20;                   if a.UserInputType == Enum.UserInputType.MouseButton1 and (mouseDownConnection.Connected) then

&#x20;                       disconnect()

&#x20;                   end

&#x20;               end)

&#x20;           end)

&#x20;

&#x20;           if default \~= min then

&#x20;               local percent = 1 - ((max - default) / (max - min))

&#x20;               local number  = default

&#x20;

&#x20;               number = tonumber(string.format("%.2f", number))

&#x20;               if (not precise) then

&#x20;                   number = math.floor(number)

&#x20;               end

&#x20;

&#x20;               overlay.Container.Button.Position  = UDim2.new(math.clamp(percent, 0, 0.99), 0,  0, 1)

&#x20;               overlay.Container.ValueLabel.Text  = number

&#x20;           end

&#x20;

&#x20;           self:Resize();

&#x20;           return {

&#x20;               Set = function(self, value)

&#x20;                   local percent = 1 - ((max - value) / (max - min))

&#x20;                   local number  = value

&#x20;

&#x20;                   number = tonumber(string.format("%.2f", number))

&#x20;                   if (not precise) then

&#x20;                       number = math.floor(number)

&#x20;                   end

&#x20;

&#x20;                   overlay.Container.Button.Position  = UDim2.new(math.clamp(percent, 0, 0.99), 0,  0, 1)

&#x20;                   overlay.Container.ValueLabel.Text  = number

&#x20;                   location\[flag] = number

&#x20;                   callback(number)

&#x20;               end

&#x20;           }

&#x20;       end

&#x20;

&#x20;       function types:SearchBox(text, options, callback)

&#x20;           local list = options.list or {};

&#x20;           local flag = options.flag or "";

&#x20;           local location = options.location or self.flags;

&#x20;           local callback = callback or function() end;

&#x20;

&#x20;           local busy = false;

&#x20;           local box = library:Create('Frame', {

&#x20;               BackgroundTransparency = 1;

&#x20;               Size = UDim2.new(1, 0, 0, 25);

&#x20;               LayoutOrder = self:GetOrder();

&#x20;               library:Create('TextBox', {

&#x20;                   Text = "";

&#x20;                   PlaceholderText = text;

&#x20;                   PlaceholderColor3 = Color3.fromRGB(60, 60, 60);

&#x20;                   Font = library.options.font;

&#x20;                   TextSize = library.options.fontsize;

&#x20;                   Name = 'Box';

&#x20;                   Size = UDim2.new(1, -10, 0, 20);

&#x20;                   Position = UDim2.new(0, 5, 0, 4);

&#x20;                   TextColor3 = library.options.textcolor;

&#x20;                   BackgroundColor3 = library.options.dropcolor;

&#x20;                   BorderColor3 = library.options.bordercolor;

&#x20;                   TextStrokeTransparency = library.options.textstroke;

&#x20;                   TextStrokeColor3 = library.options.strokecolor;

&#x20;                   library:Create('ScrollingFrame', {

&#x20;                       Position = UDim2.new(0, 0, 1, 1);

&#x20;                       Name = 'Container';

&#x20;                       BackgroundColor3 = library.options.btncolor;

&#x20;                       ScrollBarThickness = 0;

&#x20;                       BorderSizePixel = 0;

&#x20;                       BorderColor3 = library.options.bordercolor;

&#x20;                       Size = UDim2.new(1, 0, 0, 0);

&#x20;                       library:Create('UIListLayout', {

&#x20;                           Name = 'ListLayout';

&#x20;                           SortOrder = Enum.SortOrder.LayoutOrder;

&#x20;                       });

&#x20;                       ZIndex = 2;

&#x20;                   });

&#x20;               });

&#x20;               Parent = self.container;

&#x20;           })

&#x20;

&#x20;           local function rebuild(text)

&#x20;               box:FindFirstChild('Box').Container.ScrollBarThickness = 0

&#x20;               for i, child in next, box:FindFirstChild('Box').Container:GetChildren() do

&#x20;                   if (not child:IsA('UIListLayout')) then

&#x20;                       child:Destroy();

&#x20;                   end

&#x20;               end

&#x20;

&#x20;               if #text > 0 then

&#x20;                   for i, v in next, list do

&#x20;                       if string.sub(string.lower(v), 1, string.len(text)) == string.lower(text) then

&#x20;                           local button = library:Create('TextButton', {

&#x20;                               Text = v;

&#x20;                               Font = library.options.font;

&#x20;                               TextSize = library.options.fontsize;

&#x20;                               TextColor3 = library.options.textcolor;

&#x20;                               BorderColor3 = library.options.bordercolor;

&#x20;                               TextStrokeTransparency = library.options.textstroke;

&#x20;                               TextStrokeColor3 = library.options.strokecolor;

&#x20;                               Parent = box:FindFirstChild('Box').Container;

&#x20;                               Size = UDim2.new(1, 0, 0, 20);

&#x20;                               LayoutOrder = i;

&#x20;                               BackgroundColor3 = library.options.btncolor;

&#x20;                               ZIndex = 2;

&#x20;                           })

&#x20;

&#x20;                           button.MouseButton1Click:connect(function()

&#x20;                               busy = true;

&#x20;                               box:FindFirstChild('Box').Text = button.Text;

&#x20;                               wait();

&#x20;                               busy = false;

&#x20;

&#x20;                               location\[flag] = button.Text;

&#x20;                               callback(location\[flag])

&#x20;

&#x20;                               box:FindFirstChild('Box').Container.ScrollBarThickness = 0

&#x20;                               for i, child in next, box:FindFirstChild('Box').Container:GetChildren() do

&#x20;                                   if (not child:IsA('UIListLayout')) then

&#x20;                                       child:Destroy();

&#x20;                                   end

&#x20;                               end

&#x20;                               box:FindFirstChild('Box').Container:TweenSize(UDim2.new(1, 0, 0, 0), 'Out', 'Quad', 0.25, true)

&#x20;                           end)

&#x20;                       end

&#x20;                   end

&#x20;               end

&#x20;

&#x20;               local c = box:FindFirstChild('Box').Container:GetChildren()

&#x20;               local ry = (20 \* (#c)) - 20

&#x20;

&#x20;               local y = math.clamp((20 \* (#c)) - 20, 0, 100)

&#x20;               if ry > 100 then

&#x20;                   box:FindFirstChild('Box').Container.ScrollBarThickness = 5;

&#x20;               end

&#x20;

&#x20;               box:FindFirstChild('Box').Container:TweenSize(UDim2.new(1, 0, 0, y), 'Out', 'Quad', 0.25, true)

&#x20;               box:FindFirstChild('Box').Container.CanvasSize = UDim2.new(1, 0, 0, (20 \* (#c)) - 20)

&#x20;           end

&#x20;

&#x20;           box:FindFirstChild('Box'):GetPropertyChangedSignal('Text'):connect(function()

&#x20;               if (not busy) then

&#x20;                   rebuild(box:FindFirstChild('Box').Text)

&#x20;               end

&#x20;           end);

&#x20;

&#x20;           local function reload(new\_list)

&#x20;               list = new\_list;

&#x20;               rebuild("")

&#x20;           end

&#x20;           self:Resize();

&#x20;           return reload, box:FindFirstChild('Box');

&#x20;       end

&#x20;

&#x20;       function types:Dropdown(name, options, callback)

&#x20;           local location = options.location or self.flags;

&#x20;           local flag = options.flag or "";

&#x20;           local callback = callback or function() end;

&#x20;           local list = options.list or {};

&#x20;

&#x20;           location\[flag] = list\[1]

&#x20;           local check = library:Create('Frame', {

&#x20;               BackgroundTransparency = 1;

&#x20;               Size = UDim2.new(1, 0, 0, 25);

&#x20;               BackgroundColor3 = Color3.fromRGB(25, 25, 25);

&#x20;               BorderSizePixel = 0;

&#x20;               LayoutOrder = self:GetOrder();

&#x20;               library:Create('Frame', {

&#x20;                   Name = 'dropdown\_lbl';

&#x20;                   BackgroundTransparency = 0;

&#x20;                   BackgroundColor3 = library.options.dropcolor;

&#x20;                   Position = UDim2.new(0, 5, 0, 4);

&#x20;                   BorderColor3 = library.options.bordercolor;

&#x20;                   Size     = UDim2.new(1, -10, 0, 20);

&#x20;                   library:Create('TextLabel', {

&#x20;                       Name = 'Selection';

&#x20;                       Size = UDim2.new(1, 0, 1, 0);

&#x20;                       Text = list\[1];

&#x20;                       TextColor3 = library.options.textcolor;

&#x20;                       BackgroundTransparency = 1;

&#x20;                       Font = library.options.font;

&#x20;                       TextSize = library.options.fontsize;

&#x20;                       TextStrokeTransparency = library.options.textstroke;

&#x20;                       TextStrokeColor3 = library.options.strokecolor;

&#x20;                   });

&#x20;                   library:Create("TextButton", {

&#x20;                       Name = 'drop';

&#x20;                       BackgroundTransparency = 1;

&#x20;                       Size = UDim2.new(0, 20, 1, 0);

&#x20;                       Position = UDim2.new(1, -25, 0, 0);

&#x20;                       Text = 'v';

&#x20;                       TextColor3 = library.options.textcolor;

&#x20;                       Font = library.options.font;

&#x20;                       TextSize = library.options.fontsize;

&#x20;                       TextStrokeTransparency = library.options.textstroke;

&#x20;                       TextStrokeColor3 = library.options.strokecolor;

&#x20;                   })

&#x20;               });

&#x20;               Parent = self.container;

&#x20;           });

&#x20;

&#x20;           local button = check:FindFirstChild('dropdown\_lbl').drop;

&#x20;           local input;

&#x20;

&#x20;           button.MouseButton1Click:connect(function()

&#x20;               if (input and input.Connected) then

&#x20;                   return

&#x20;               end

&#x20;

&#x20;               check:FindFirstChild('dropdown\_lbl'):WaitForChild('Selection').TextColor3 = Color3.fromRGB(60, 60, 60);

&#x20;               check:FindFirstChild('dropdown\_lbl'):WaitForChild('Selection').Text = name;

&#x20;               local c = 0;

&#x20;               for i, v in next, list do

&#x20;                   c = c + 20;

&#x20;               end

&#x20;

&#x20;               local size = UDim2.new(1, 0, 0, c)

&#x20;

&#x20;               local clampedSize;

&#x20;               local scrollSize = 0;

&#x20;               if size.Y.Offset > 100 then

&#x20;                   clampedSize = UDim2.new(1, 0, 0, 100)

&#x20;                   scrollSize = 5;

&#x20;               end

&#x20;

&#x20;               local goSize = (clampedSize \~= nil and clampedSize) or size;

&#x20;               local container = library:Create('ScrollingFrame', {

&#x20;                   TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png';

&#x20;                   BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png';

&#x20;                   Name = 'DropContainer';

&#x20;                   Parent = check:FindFirstChild('dropdown\_lbl');

&#x20;                   Size = UDim2.new(1, 0, 0, 0);

&#x20;                   BackgroundColor3 = library.options.bgcolor;

&#x20;                   BorderColor3 = library.options.bordercolor;

&#x20;                   Position = UDim2.new(0, 0, 1, 0);

&#x20;                   ScrollBarThickness = scrollSize;

&#x20;                   CanvasSize = UDim2.new(0, 0, 0, size.Y.Offset);

&#x20;                   ZIndex = 5;

&#x20;                   ClipsDescendants = true;

&#x20;                   library:Create('UIListLayout', {

&#x20;                       Name = 'List';

&#x20;                       SortOrder = Enum.SortOrder.LayoutOrder

&#x20;                   })

&#x20;               })

&#x20;

&#x20;               for i, v in next, list do

&#x20;                   local btn = library:Create('TextButton', {

&#x20;                       Size = UDim2.new(1, 0, 0, 20);

&#x20;                       BackgroundColor3 = library.options.btncolor;

&#x20;                       BorderColor3 = library.options.bordercolor;

&#x20;                       Text = v;

&#x20;                       Font = library.options.font;

&#x20;                       TextSize = library.options.fontsize;

&#x20;                       LayoutOrder = i;

&#x20;                       Parent = container;

&#x20;                       ZIndex = 5;

&#x20;                       TextColor3 = library.options.textcolor;

&#x20;                       TextStrokeTransparency = library.options.textstroke;

&#x20;                       TextStrokeColor3 = library.options.strokecolor;

&#x20;                   })

&#x20;

&#x20;                   btn.MouseButton1Click:connect(function()

&#x20;                       check:FindFirstChild('dropdown\_lbl'):WaitForChild('Selection').TextColor3 = library.options.textcolor

&#x20;                       check:FindFirstChild('dropdown\_lbl'):WaitForChild('Selection').Text = btn.Text;

&#x20;

&#x20;                       location\[flag] = tostring(btn.Text);

&#x20;                       callback(location\[flag])

&#x20;

&#x20;                       game:GetService('Debris'):AddItem(container, 0)

&#x20;                       input:disconnect();

&#x20;                   end)

&#x20;               end

&#x20;

&#x20;               container:TweenSize(goSize, 'Out', 'Quad', 0.15, true)

&#x20;

&#x20;               local function isInGui(frame)

&#x20;                   local mloc = game:GetService('UserInputService'):GetMouseLocation();

&#x20;                   local mouse = Vector2.new(mloc.X, mloc.Y - 36);

&#x20;

&#x20;                   local x1, x2 = frame.AbsolutePosition.X, frame.AbsolutePosition.X + frame.AbsoluteSize.X;

&#x20;                   local y1, y2 = frame.AbsolutePosition.Y, frame.AbsolutePosition.Y + frame.AbsoluteSize.Y;

&#x20;

&#x20;                   return (mouse.X >= x1 and mouse.X <= x2) and (mouse.Y >= y1 and mouse.Y <= y2)

&#x20;               end

&#x20;

&#x20;               input = game:GetService('UserInputService').InputBegan:connect(function(a)

&#x20;                   if a.UserInputType == Enum.UserInputType.MouseButton1 and (not isInGui(container)) then

&#x20;                       check:FindFirstChild('dropdown\_lbl'):WaitForChild('Selection').TextColor3 = library.options.textcolor

&#x20;                       check:FindFirstChild('dropdown\_lbl'):WaitForChild('Selection').Text       = location\[flag];

&#x20;

&#x20;                       container:TweenSize(UDim2.new(1, 0, 0, 0), 'In', 'Quad', 0.15, true)

&#x20;                       wait(0.15)

&#x20;

&#x20;                       game:GetService('Debris'):AddItem(container, 0)

&#x20;                       input:disconnect();

&#x20;                   end

&#x20;               end)

&#x20;           end)

&#x20;

&#x20;           self:Resize();

&#x20;           local function reload(self, array)

&#x20;               options = array;

&#x20;               location\[flag] = array\[1];

&#x20;               pcall(function()

&#x20;                   input:disconnect()

&#x20;               end)

&#x20;               check:WaitForChild('dropdown\_lbl').Selection.Text = location\[flag]

&#x20;               check:FindFirstChild('dropdown\_lbl'):WaitForChild('Selection').TextColor3 = library.options.textcolor

&#x20;               game:GetService('Debris'):AddItem(container, 0)

&#x20;           end

&#x20;

&#x20;           return {

&#x20;               Refresh = reload;

&#x20;           }

&#x20;       end

&#x20;   end

&#x20;

&#x20;   function library:Create(class, data)

&#x20;       local obj = Instance.new(class);

&#x20;       for i, v in next, data do

&#x20;           if i \~= 'Parent' then

&#x20;

&#x20;               if typeof(v) == "Instance" then

&#x20;                   v.Parent = obj;

&#x20;               else

&#x20;                   obj\[i] = v

&#x20;               end

&#x20;           end

&#x20;       end

&#x20;

&#x20;       obj.Parent = data.Parent;

&#x20;       return obj

&#x20;   end

&#x20;

&#x20;   function library:CreateWindow(name, options)

&#x20;       if (not library.container) then

&#x20;           library.container = self:Create("ScreenGui", {

&#x20;               self:Create('Frame', {

&#x20;                   Name = 'Container';

&#x20;                   Size = UDim2.new(1, -30, 1, 0);

&#x20;                   Position = UDim2.new(0, 20, 0, 20);

&#x20;                   BackgroundTransparency = 1;

&#x20;                   Active = false;

&#x20;               });

&#x20;               Parent = game:GetService("CoreGui");

&#x20;           }):FindFirstChild('Container');

&#x20;       end

&#x20;

&#x20;       if (not library.options) then

&#x20;           library.options = setmetatable(options or {}, {\_\_index = defaults})

&#x20;       end

&#x20;

&#x20;       local window = types.window(name, library.options);

&#x20;       dragger.new(window.object);

&#x20;       return window

&#x20;   end

&#x20;

&#x20;   default = {

&#x20;       topcolor       = Color3.fromRGB(30, 30, 30);

&#x20;       titlecolor     = Color3.fromRGB(255, 255, 255);

&#x20;

&#x20;       underlinecolor = Color3.fromRGB(0, 255, 140);

&#x20;       bgcolor        = Color3.fromRGB(35, 35, 35);

&#x20;       boxcolor       = Color3.fromRGB(35, 35, 35);

&#x20;       btncolor       = Color3.fromRGB(25, 25, 25);

&#x20;       dropcolor      = Color3.fromRGB(25, 25, 25);

&#x20;       sectncolor     = Color3.fromRGB(25, 25, 25);

&#x20;       bordercolor    = Color3.fromRGB(80, 80, 80);

&#x20;

&#x20;       font           = Enum.Font.SourceSans;

&#x20;       titlefont      = Enum.Font.Code;

&#x20;

&#x20;       fontsize       = 17;

&#x20;       titlesize      = 18;

&#x20;

&#x20;       textstroke     = 1;

&#x20;       titlestroke    = 1;

&#x20;

&#x20;       strokecolor    = Color3.fromRGB(0, 0, 0);

&#x20;

&#x20;       textcolor      = Color3.fromRGB(255, 255, 255);

&#x20;       titletextcolor = Color3.fromRGB(255, 255, 255);

&#x20;

&#x20;       placeholdercolor = Color3.fromRGB(255, 255, 255);

&#x20;       titlestrokecolor = Color3.fromRGB(0, 0, 0);

&#x20;   }

&#x20;

&#x20;   library.options = setmetatable({}, {\_\_index = default})

&#x20;

&#x20;   spawn(function()

&#x20;       while true do

&#x20;           for i=0, 1, 1 / 300 do

&#x20;               for \_, obj in next, library.rainbowtable do

&#x20;                   obj.BackgroundColor3 = Color3.fromHSV(i, 1, 1);

&#x20;               end

&#x20;               wait()

&#x20;           end;

&#x20;       end

&#x20;   end)

&#x20;

&#x20;   local function isreallypressed(bind, inp)

&#x20;       local key = bind

&#x20;       if typeof(key) == "Instance" then

&#x20;           if key.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == key.KeyCode then

&#x20;               return true;

&#x20;           elseif tostring(key.UserInputType):find('MouseButton') and inp.UserInputType == key.UserInputType then

&#x20;               return true

&#x20;           end

&#x20;       end

&#x20;       if tostring(key):find'MouseButton1' then

&#x20;           return key == inp.UserInputType

&#x20;       else

&#x20;           return key == inp.KeyCode

&#x20;       end

&#x20;   end

&#x20;

&#x20;   game:GetService("UserInputService").InputBegan:connect(function(input)

&#x20;       if (not library.binding) then

&#x20;           for idx, binds in next, library.binds do

&#x20;               local real\_binding = binds.location\[idx];

&#x20;               if real\_binding and isreallypressed(real\_binding, input) then

&#x20;                   binds.callback()

&#x20;               end

&#x20;           end

&#x20;       end

&#x20;   end)

end

library.options.underlinecolor = Color3.fromRGB(0, 170, 255)

&#x20;

\-- Farming Tab

local Farming = library:CreateWindow("Farming")

Farming:Section("- Karma Farms -")

local GK = Farming:Toggle("Auto-Good Karma", {flag = "GK"})

local BK = Farming:Toggle("Auto-Bad Karma", {flag = "BK"})

Farming:Section("- Ultra Coins -")

local Swing = Farming:Toggle("Auto-Swing", {flag = "Swing"})

local Sell = Farming:Toggle("Auto-Sell", {flag = "Sell"})

local BackpackFull = Farming:Toggle("Auto-Full Sell", {flag = "FullSell"})

Farming:Section("- Ultra Chi -")

local Chi = Farming:Toggle("Auto-Chi", {flag = "Chi"})

Farming:Section("- Boss Farms -")

local Boss = Farming:Toggle("Auto-Robot Boss", {flag = "Boss"})

local ETBoss = Farming:Toggle("Auto-Eternal Boss", {flag = "EBoss"})

local AMBoss = Farming:Toggle("Auto-Ancient Boss", {flag = "ABoss"})

local SNB = Farming:Toggle("Auto-Santa Boss", {flag = "SBoss"})

local AllBoss = Farming:Toggle("Auto-All Bosses", {flag = "AllBosses"})

Farming:Section("- Give Pet Levels -")

local EAR = Farming:Toggle("Auto-Pet Levels", {flag = "L"})

&#x20;

\-- Auto-Buy Tab

local AutoBuy = library:CreateWindow("Auto-Buy")

AutoBuy:Section("- Auto-Buy Stuff -")

local Rank = AutoBuy:Toggle("Auto-Rank", {flag = "Rank"})

local Sword = AutoBuy:Toggle("Auto-Sword", {flag = "Sword"})

local Belt = AutoBuy:Toggle("Auto-Belt", {flag = "Belt"})

local Skill = AutoBuy:Toggle("Auto-Skills", {flag = "Skill"})

local Shuriken = AutoBuy:Toggle("Auto-Shurikens", {flag = "Shurikens"})

\_G.Enabled = AutoBuy.flags.Purchase

\_G.Sword = AutoBuy.flags.Sword

\_G.Belt = AutoBuy.flags.Belt

\_G.Rank = AutoBuy.flags.Rank

\_G.Skill = AutoBuy.flags.Skill

&#x20;

local Pets = library:CreateWindow("Pet Stuff")

\-- Open Pets

Pets:Section("- Open Pets -")

local Settings = {}

local Crystals = {}

for i,v in next, game.workspace.mapCrystalsFolder:GetChildren() do

if v then

table.insert(Crystals,v.Name)

end

end

Pets:Dropdown('Crystals', {location = Settings, flag = "Crystal", list = Crystals})

Pets:Toggle("Open Crystal", {location = Settings, flag = "TEgg"})

&#x20;

\-- Pet Options

Pets:Section("- Pet Options -")

local Evolve = Pets:Toggle("Auto-Evolve", {flag = "Evolve"})

local Eternalise = Pets:Toggle("Auto-Eternalise", {flag = "Eternalise"})

local Immortalize = Pets:Toggle("Auto-Immortalize", {flag = "Immortalize"})

local Legend = Pets:Toggle("Auto-Legend", {flag = "Legend"})

local Elemental = Pets:Toggle("Auto-Elementalize", {flag = "Elemental"})

&#x20;

\-- Sell Pets

Pets:Section("- Sell Pets -")

local Basic = Pets:Toggle("Sell All Basic", {flag = "SBasic"})

local Advanced = Pets:Toggle("Sell All Advanced", {flag = "SAdvanced"})

local Rare = Pets:Toggle("Sell All Rare", {flag = "SRare"})

local Epic = Pets:Toggle("Sell All Epic", {flag = "SEpic"})

local Unique = Pets:Toggle("Sell All Unique", {flag = "SUnique"})

local Omega = Pets:Toggle("Sell All Omega", {flag = "SOmega"})

local Elite = Pets:Toggle("Sell All Elite", {flag = "SElite"})

local Infinity = Pets:Toggle("Sell All Infinity", {flag = "SInfinity"})



\-- Misc

local Misc = library:CreateWindow("Misc")

Misc:Section("- Other OP Scripts -")

local Shuriken = Misc:Toggle("Fast Shuriken", {flag = "Fast"})

local Shuriken2 = Misc:Toggle("Slow Shuriken", {flag = "Slow"})

local Invis = Misc:Toggle("Invisibility", {flag = "Invis"})

&#x20;

\-- Collect All Chest

local ChestCollect = Misc:Button("Collect All Chest", function()

game:GetService("Workspace").mythicalChest\["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

wait(3.5)

game:GetService("Workspace").goldenChest\["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

wait(3.5)

game:GetService("Workspace").enchantedChest\["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

wait(3.5)

game:GetService("Workspace").magmaChest\["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

wait(3.5)

game:GetService("Workspace").legendsChest\["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

wait(3.5)

game:GetService("Workspace").eternalChest\["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

wait(3.5)

game:GetService("Workspace").saharaChest\["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

wait(3.5)

game:GetService("Workspace").thunderChest\["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

wait(3.5)

game:GetService("Workspace").ancientChest\["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

wait(3.5)

game:GetService("Workspace").midnightShadowChest\["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

wait(3.5)

game:GetService("Workspace").groupRewardsCircle\["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

wait(3.5)

game:GetService("Workspace")\["Daily Chest"].circleInner.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

wait(3.5)

game:GetService("Workspace")\["wonderChest"].circleInner.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

wait(3.5)

game:GetService("Workspace").wonderChest\["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

game:GetService("Workspace").midnightShadowChest\["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

game:GetService("Workspace").ancientChest\["circleInner"].CFrame = game.Workspace.Part.CFrame

game:GetService("Workspace").midnightShadowChest\["circleInner"].CFrame = game.Workspace.Part.CFrame

game:GetService("Workspace").thunderChest\["circleInner"].CFrame = game.Workspace.Part.CFrame

game:GetService("Workspace").saharaChest\["circleInner"].CFrame = game.Workspace.Part.CFrame

game:GetService("Workspace").eternalChest\["circleInner"].CFrame = game.Workspace.Part.CFrame

game:GetService("Workspace").legendsChest\["circleInner"].CFrame = game.Workspace.Part.CFrame

game:GetService("Workspace").magmaChest\["circleInner"].CFrame = game.Workspace.Part.CFrame

game:GetService("Workspace").enchantedChest\["circleInner"].CFrame = game.Workspace.Part.CFrame

game:GetService("Workspace").goldenChest\["circleInner"].CFrame = game.Workspace.Part.CFrame

game:GetService("Workspace").mythicalChest\["circleInner"].CFrame = game.Workspace.Part.CFrame

game:GetService("Workspace").groupRewardsCircle\["circleInner"].CFrame = game.Workspace.Part.CFrame

game:GetService("Workspace")\["Daily Chest"].circleInner.CFrame = game.Workspace.Part.CFrame

end)

&#x20;

\-- Collect Light Karma Chest

local LightKarma = Misc:Button("Collect Light Chest", function()

game:GetService("Workspace").lightKarmaChest\["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

wait(5)

game:GetService("Workspace").lightKarmaChest\["circleInner"].CFrame = game.Workspace.Part.CFrame

end)

&#x20;

\-- Collect Dark Karma Chest

local ChestCollect = Misc:Button("Collect Evil Chest", function()

game:GetService("Workspace").evilKarmaChest\["circleInner"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

wait(5)

game:GetService("Workspace").evilKarmaChest\["circleInner"].CFrame = game.Workspace.Part.CFrame

end)

&#x20;

\-- Unlock All Islands

local UnlockIsland = Misc:Button("Unlock Islands", function()

for i,v in next, game.workspace.islandUnlockParts:GetChildren() do

if v then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.islandSignPart.CFrame;

wait(.5)

end

end

end)

&#x20;

\-- Max Jump

local MaxJP = Misc:Button("Max Jumps", function()

while wait(.0001) do

game.Players.LocalPlayer.multiJumpCount.Value = "50"

end

end)

&#x20;

\-- Hide Name

local HideName = Misc:Button("Hide Name", function()

local plrname = game.Players.LocalPlayer.Name

workspace\[plrname].Head.nameGui:Destroy()

end)

&#x20;

\-- ESP toggle flag

\_G.ESPEnabled = false



\-- ESP

local ESP = Misc:Button("ESP", function()

&#x20;   \_G.ESPEnabled = true



&#x20;   function isnil(thing)

&#x20;       return (thing == nil)

&#x20;   end



&#x20;   local function round(n)

&#x20;       return math.floor(tonumber(n) + 0.5)

&#x20;   end



&#x20;   function UpdatePlayerChams()

&#x20;       for i,v in pairs(game:GetService'Players':GetChildren()) do

&#x20;           pcall(function()

&#x20;               if not isnil(v.Character) then

&#x20;                   for \_,k in pairs(v.Character:GetChildren()) do

&#x20;                       if k:IsA'BasePart' and not k:FindFirstChild'Cham' then

&#x20;                           local cham = Instance.new('BoxHandleAdornment',k)

&#x20;                           cham.ZIndex= 10

&#x20;                           cham.Adornee=k

&#x20;                           cham.AlwaysOnTop=true

&#x20;                           cham.Size=k.Size

&#x20;                           cham.Transparency=.8

&#x20;                           cham.Color3=Color3.new(0,0,1)

&#x20;                           cham.Name = 'Cham'

&#x20;                       end

&#x20;                   end

&#x20;                   if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild'NameEsp' then

&#x20;                       local bill = Instance.new('BillboardGui',v.Character.Head)

&#x20;                       bill.Name = 'NameEsp'

&#x20;                       bill.Size=UDim2.new(1,200,1,30)

&#x20;                       bill.Adornee=v.Character.Head

&#x20;                       bill.AlwaysOnTop=true

&#x20;                       local name = Instance.new('TextLabel',bill)

&#x20;                       name.TextWrapped=true

&#x20;                       name.Text = (v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..'m')

&#x20;                       name.Size = UDim2.new(1,0,1,0)

&#x20;                       name.TextYAlignment='Top'

&#x20;                       name.TextColor3=Color3.new(1,1,1)

&#x20;                       name.BackgroundTransparency=1

&#x20;                   else

&#x20;                       v.Character.Head.NameEsp.TextLabel.Text = (v.Name ..' '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..'m')

&#x20;                   end

&#x20;               end

&#x20;           end)

&#x20;       end

&#x20;   end



&#x20;   spawn(function()

&#x20;       while wait() do

&#x20;           if not \_G.ESPEnabled then break end

&#x20;           UpdatePlayerChams()

&#x20;       end

&#x20;   end)

end)



\-- ESP Removal

local RemoveESP = Misc:Button("Remove ESP", function()

&#x20;   \_G.ESPEnabled = false

&#x20;   for \_, player in pairs(game:GetService("Players"):GetPlayers()) do

&#x20;       if player.Character then

&#x20;           for \_, part in pairs(player.Character:GetDescendants()) do

&#x20;               if part:IsA("BoxHandleAdornment") and part.Name == "Cham" then

&#x20;                   part:Destroy()

&#x20;               elseif part:IsA("BillboardGui") and part.Name == "NameEsp" then

&#x20;                   part:Destroy()

&#x20;               end

&#x20;           end

&#x20;       end

&#x20;   end

end)



\-- Toggle Popups (Chi/Coin thigns)

Misc:Bind("Toggle Popups",

{flag = "pop", owo = true},

function()

game:GetService("Players").LocalPlayer.PlayerGui.statEffectsGui.Enabled = not game:GetService("Players").LocalPlayer.PlayerGui.statEffectsGui.Enabled

game:GetService("Players").LocalPlayer.PlayerGui.hoopGui.Enabled = not game:GetService("Players").LocalPlayer.PlayerGui.hoopGui.Enabled

end)

&#x20;

\-- Toggable GUI Key

Misc:Bind("Toggle GUI Key",

{flag = "Toggle", owo = true},

function()

library.toggled = not library.toggled;

for i, data in next, library.queue do

local pos = (library.toggled and data.p or UDim2.new(-1, 0, -0.5,0))

data.w:TweenPosition(pos, (library.toggled and 'Out' or 'In'), 'Quad', 0.15, true)

wait();

end

end)

&#x20;

\-- Destroy GUI

local Kill = Misc:Button("Destroy GUI", function()

game:GetService("CoreGui").ScreenGui:Destroy()

end)

&#x20;

local Teleports = library:CreateWindow("Teleports")

&#x20;

\-- World/Island Teleports

Teleports:Section("- Islands -")

local Islands = {}

for i,v in next, game.workspace.islandUnlockParts:GetChildren() do

if v then

table.insert(Islands, v.Name)

end

end

Teleports:Dropdown('Teleports', {list = Islands}, function(a)

&#x20;   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.islandUnlockParts\[a].islandSignPart.CFrame

end)

&#x20;

\-- Utilitys

Teleports:Section("- Utilitys -")

local Shop = Teleports:Button("Shop", function()

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").shopAreaCircles\["shopAreaCircle11"].circleInner.CFrame

end)

local Skills = Teleports:Button("Skills Shop", function()

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").skillAreaCircles\["skillsAreaCircle11"].circleInner.CFrame

end)

local Skills1 = Teleports:Button("Light Skills Shop", function()

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-116.49514, 3.24800324, 0.0838552266)

end)

local Skills2 = Teleports:Button("Dark Skills Shop", function()

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-116.549767, 3.24800324, 58.087841)

end)

local KOTH = Teleports:Button("KOTH", function()

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").kingOfTheHillPart.CFrame

end)

&#x20;

\-- Training Area Teleports

Teleports:Section("- Training Areas -")

local a1 = Teleports:Button("Mystical Waters (Good)", function()

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(347.74881, 8824.53809, 114.271019)

end)

local a2 = Teleports:Button("Sword of Legends (Good)", function()

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1834.15967, 38.704483, -141.375641)

end)

local a5 = Teleports:Button("Elemental Tornado (Good)", function()

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(299.758484, 30383.0957, -90.1542206)

end)

local a3 = Teleports:Button("Lava Pit (Bad)", function()

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-116.631485, 12952.5381, 271.14624)

end)

local a4 = Teleports:Button("Tornado (Bad)", function()

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(325.641174, 16872.0938, -9.9906435)

end)

local a6 = Teleports:Button("Swords Of Ancients (Bad)", function()

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(648.365662, 38.704483, 2409.72266)

end)

&#x20;

if \_G.PlaceLoopTP == true then

local Teleports2 = library:CreateWindow("More Teleports")

Teleports2:Section("- Training Areas (Looped) -")

local avh = Teleports2:Button("Mystical Waters (Good)", function()

while true do

wait(.001)

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(347.74881, 8824.53809, 114.271019)

end

end

end)

local sdgy6 = Teleports2:Button("Sword of Legends (Good)", function()

while true do

wait(.001)

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1834.15967, 38.704483, -141.375641)

end

end

end)

local asdy = Teleports2:Button("Elemental Tornado (Good)", function()

while true do

wait(.001)

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(299.758484, 30383.0957, -90.1542206)

end

end

end)

local yassf = Teleports2:Button("Lava Pit (Bad)", function()

while true do

wait(.001)

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-116.631485, 12952.5381, 271.14624)

end

end

end)

local sdfj = Teleports2:Button("Tornado (Bad)", function()

while true do

wait(.001)

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(325.641174, 16872.0938, -9.9906435)

end

end

end)

local jhas = Teleports2:Button("Swords Of Ancients (Bad)", function()

while true do

wait(.001)

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(648.365662, 38.704483, 2409.72266)

end

end

end)

end

&#x20;

&#x20;

&#x20;

\-- Open Crystals

spawn(function()

while wait(.01) do

if Settings.TEgg then

local oh1 = "openCrystal"

local oh2 = Settings.Crystal

game:GetService("ReplicatedStorage").rEvents.openCrystalRemote:InvokeServer(oh1, oh2)

end

end

end)

&#x20;

\-- Auto-Swing

spawn(function()

while wait() do

if Farming.flags.Swing then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then

game.Players.LocalPlayer.ninjaEvent:FireServer("swingKatana")

else

for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do

if v.ClassName == "Tool" and v:FindFirstChild("attackShurikenScript") then

game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)

wait()

if v.ClassName == "Tool" and v:FindFirstChild("attackKatanaScript") then

game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)

end

end

end

end

end

end

end

end)

&#x20;

\-- Auto-Sell

spawn(function()

while wait(0.01) do

if Farming.flags.Sell then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

game.workspace.sellAreaCircles\["sellAreaCircle7"].circleInner.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame

wait(.1)

game.workspace.sellAreaCircles\["sellAreaCircle7"].circleInner.CFrame = game.Workspace.Part.CFrame

end

end

end

end)

&#x20;

\-- Auto-Full Sell

spawn(function()

while wait(0.01) do

if Farming.flags.FullSell then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

if player.PlayerGui.gameGui.maxNinjitsuMenu.Visible == true then

game.workspace.sellAreaCircles\["sellAreaCircle7"].circleInner.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame

wait(.05)

game.workspace.sellAreaCircles\["sellAreaCircle7"].circleInner.CFrame = game.Workspace.Part.CFrame

end

end

end

end

end)

&#x20;

\-- Invisibility

spawn(function()

while wait(0.001) do

if Misc.flags.Invis then

local A\_1 = "goInvisible"

local Event = game.Players.LocalPlayer.ninjaEvent

Event:FireServer(A\_1)

end

end

end)

&#x20;

\-- Auto-Pet Levels

spawn(function()

while wait(0.1) do

if Farming.flags.L then

local plr = game.Players.LocalPlayer

for \_,v in pairs(workspace.Hoops:GetDescendants()) do

if v.ClassName == "MeshPart" then

v.touchPart.CFrame = plr.Character.HumanoidRootPart.CFrame

end

end

end

end

end)

&#x20;

\-- Good Karma Farm

spawn(function()

while wait(0.4) do

if Farming.flags.GK then

loadstring(game:HttpGet(('https://pastebin.com/raw/AaqHqPyw'),true))()

end

end

end)

&#x20;

\-- Bad Karma Farm

spawn(function()

while wait(0.4) do

if Farming.flags.BK then

loadstring(game:HttpGet(('https://pastebin.com/raw/wEEB3nQt'),true))()

end

end

end)

&#x20;

\-- Auto-Normal Boss

spawn(function()

while wait(0.1) do

if Farming.flags.Boss then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

if game:GetService("Workspace").bossFolder:WaitForChild("RobotBoss"):WaitForChild("HumanoidRootPart") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.RobotBoss.HumanoidRootPart.CFrame

if player.Character:FindFirstChildOfClass("Tool") then

player.Character:FindFirstChildOfClass("Tool"):Activate()

else

for i,v in pairs(player.Backpack:GetChildren()) do

if v.ClassName == "Tool" and v:FindFirstChild("attackKatanaScript") then

v.attackTime.Value = 0.2

player.Character.Humanoid:EquipTool(v)

if attackfar then

for i,v in pairs(player.Backpack:GetChildren()) do

if v.ClassName == "Tool" and v:FindFirstChild("attackShurikenScript") then

player.Character.Humanoid:EquipTool(v)

end

end

end

end

end

end

end

end

end

end

end)

&#x20;

\-- Auto-Eternal Boss

spawn(function()

while wait(0.1) do

if Farming.flags.EBoss then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

if game:GetService("Workspace").bossFolder:WaitForChild("EternalBoss"):WaitForChild("HumanoidRootPart") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.EternalBoss.HumanoidRootPart.CFrame

if player.Character:FindFirstChildOfClass("Tool") then

player.Character:FindFirstChildOfClass("Tool"):Activate()

else

for i,v in pairs(player.Backpack:GetChildren()) do

if v.ClassName == "Tool" and v:FindFirstChild("attackKatanaScript") then

v.attackTime.Value = 0.2

player.Character.Humanoid:EquipTool(v)

if attackfar then

for i,v in pairs(player.Backpack:GetChildren()) do

if v.ClassName == "Tool" and v:FindFirstChild("attackShurikenScript") then

player.Character.Humanoid:EquipTool(v)

end

end

end

end

end

end

end

end

end

end

end)

&#x20;

\-- Auto-Anchient Boss

spawn(function()

while wait(0.1) do

if Farming.flags.ABoss then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

if game:GetService("Workspace").bossFolder:WaitForChild("AncientMagmaBoss"):WaitForChild("HumanoidRootPart") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.AncientMagmaBoss.HumanoidRootPart.CFrame

if player.Character:FindFirstChildOfClass("Tool") then

player.Character:FindFirstChildOfClass("Tool"):Activate()

else

for i,v in pairs(player.Backpack:GetChildren()) do

if v.ClassName == "Tool" and v:FindFirstChild("attackKatanaScript") then

v.attackTime.Value = 0.2

player.Character.Humanoid:EquipTool(v)

if attackfar then

for i,v in pairs(player.Backpack:GetChildren()) do

if v.ClassName == "Tool" and v:FindFirstChild("attackShurikenScript") then

player.Character.Humanoid:EquipTool(v)

end

end

end

end

end

end

end

end

end

end

end)

&#x20;

spawn(function()

while wait(0.1) do

if Farming.flags.SBoss then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

if game:GetService("Workspace").bossFolder:WaitForChild("Samurai Santa"):WaitForChild("HumanoidRootPart") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder\["Samurai Santa"].HumanoidRootPart.CFrame

if player.Character:FindFirstChildOfClass("Tool") then

player.Character:FindFirstChildOfClass("Tool"):Activate()

else

for i,v in pairs(player.Backpack:GetChildren()) do

if v.ClassName == "Tool" and v:FindFirstChild("attackKatanaScript") then

v.attackTime.Value = 0.2

player.Character.Humanoid:EquipTool(v)

if attackfar then

for i,v in pairs(player.Backpack:GetChildren()) do

if v.ClassName == "Tool" and v:FindFirstChild("attackShurikenScript") then

player.Character.Humanoid:EquipTool(v)

end

end

end

end

end

end

end

end

end

end

end)

&#x20;

\-- Auto-All Bosses

spawn(function()

while wait(0.1) do

if Farming.flags.AllBosses then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

if game.Workspace.bossFolder:FindFirstChild("Samurai Santa") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder\["Samurai Santa"].HumanoidRootPart.CFrame

else

if not game.Workspace.bossFolder:FindFirstChild("Samurai Santa") then

if game.Workspace.bossFolder:FindFirstChild("AncientMagmaBoss") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.AncientMagmaBoss.HumanoidRootPart.CFrame

else

if not game.Workspace.bossFolder:FindFirstChild("AncientMagmaBoss") then

if game.Workspace.bossFolder:FindFirstChild("EternalBoss") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.EternalBoss.HumanoidRootPart.CFrame

else

if not game.Workspace.bossFolder:FindFirstChild("EternalBoss") then

if game.Workspace.bossFolder:FindFirstChild("RobotBoss") then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.bossFolder.RobotBoss.HumanoidRootPart.CFrame

end

end

end

end

end

end

end

if player.Character:FindFirstChildOfClass("Tool") then

player.Character:FindFirstChildOfClass("Tool"):Activate()

else

for i,v in pairs(player.Backpack:GetChildren()) do

if v.ClassName == "Tool" and v:FindFirstChild("attackKatanaScript") then

v.attackTime.Value = 0.2

player.Character.Humanoid:EquipTool(v)

if attackfar then

for i,v in pairs(player.Backpack:GetChildren()) do

if v.ClassName == "Tool" and v:FindFirstChild("attackShurikenScript") then

player.Character.Humanoid:EquipTool(v)

end

end

end

end

end

end

end

end

end

end)

&#x20;

\-- Auto-Buy Swords

spawn(function()

while wait(0.5) do

if AutoBuy.flags.Sword then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

local oh1 = "buyAllSwords"

local oh2 = {"Ground", "Astral Island", "Space Island","Tundra Island", "Eternal Island", "Sandstorm", "Thunderstorm", "Ancient Inferno Island", "Midnight Shadow Island", "Mythical Souls Island", "Winter Wonder Island"}

for i = 1,#oh2 do

game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(oh1, oh2\[i])

end

end

end

end

end)

&#x20;

\-- Auto-Buy Belts

spawn(function()

while wait(0.5) do

if AutoBuy.flags.Belt then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

local oh1 = "buyAllBelts"

local oh2 = {"Ground", "Astral Island", "Space Island","Tundra Island", "Eternal Island", "Sandstorm", "Thunderstorm", "Ancient Inferno Island", "Midnight Shadow Island", "Mythical Souls Island", "Winter Wonder Island"}

for i = 1,#oh2 do

game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(oh1, oh2\[i])

end

end

end

end

end)

&#x20;

\-- Auto-Buy Skills

spawn(function()

while wait(0.5) do

if AutoBuy.flags.Skill then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

local oh1 = "buyAllSkills"

local oh2 = {"Ground", "Astral Island", "Space Island","Tundra Island", "Eternal Island", "Sandstorm", "Thunderstorm", "Ancient Inferno Island", "Midnight Shadow Island", "Mythical Souls Island", "Winter Wonder Island"}

for i = 1,#oh2 do

game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(oh1, oh2\[i])

end

end

end

end

end)

&#x20;

\-- Auto-Buy Ranks

spawn(function()

while wait(0.5) do

if AutoBuy.flags.Rank then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

local oh1 = "buyRank"

local oh2 = game:GetService("ReplicatedStorage").Ranks.Ground:GetChildren()

for i = 1,#oh2 do

game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(oh1, oh2\[i].Name)

end

end

end

end

end)

&#x20;

\-- Auto-Buy Shurikens

spawn(function()

while wait(0.5) do

if AutoBuy.flags.Shurikens then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

local oh1 = "buyAllShurikens"

local oh2 = {"Ground", "Astral Island", "Space Island","Tundra Island", "Eternal Island", "Sandstorm", "Thunderstorm", "Ancient Inferno Island", "Midnight Shadow Island", "Mythical Souls Island", "Winter Wonder Island"}

for i = 1,#oh2 do

game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(oh1, oh2\[i])

end

end

end

end

end)

&#x20;

\-- Auto-Chi

spawn(function()

while wait(0.1) do

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

if Farming.flags.Chi then

for i,v in pairs(game.Workspace.spawnedCoins.Valley:GetChildren()) do

if v.Name == "Blue Chi Crate" then

game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position)

wait(.16)

end

end

end

end

end

end)

&#x20;

\-- Auto Evolve Pet

spawn(function()

while wait(3) do

if Pets.flags.Evolve then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do

for i,x in pairs(v:GetChildren()) do

local oh1 = "evolvePet"

local oh2 = x.Name

game:GetService("ReplicatedStorage").rEvents.petEvolveEvent:FireServer(oh1, oh2)

end

end

end

end

end

end)

&#x20;

\-- Auto-Eternalize Pet

spawn(function()

while wait(3) do

if Pets.flags.Eternalise then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do

for i,x in pairs(v:GetChildren()) do

local oh1 = "eternalizePet"

local oh2 = x.Name

game:GetService("ReplicatedStorage").rEvents.petEternalizeEvent:FireServer(oh1, oh2)

end

end

end

end

end

end)

&#x20;

\-- Auto-Immortalize Pet

spawn(function()

while wait(3) do

if Pets.flags.Immortalize then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do

for i,x in pairs(v:GetChildren()) do

local oh1 = "immortalizePet"

local oh2 = x.Name

game:GetService("ReplicatedStorage").rEvents.petImmortalizeEvent:FireServer(oh1, oh2)

end

end

end

end

end

end)

&#x20;

\-- Auto-Legend Pet

spawn(function()

while wait(3) do

if Pets.flags.Legend then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do

for i,x in pairs(v:GetChildren()) do

local oh1 = "legendizePet"

local oh2 = x.Name

game:GetService("ReplicatedStorage").rEvents.petLegendEvent:FireServer(oh1, oh2)

end

end

end

end

end

end)

&#x20;

spawn(function()

while wait(3) do

if Pets.flags.Elemental then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do

for i,x in pairs(v:GetChildren()) do

local oh1 = "elementalizePet"

local oh2 = x.Name

game:GetService("ReplicatedStorage").rEvents.petLegendEvent:FireServer(oh1, oh2)

end

end

end

end

end

end)

&#x20;

\-- Sell All Basics

spawn(function()

while wait(1) do

if Pets.flags.SBasic then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game.Players.LocalPlayer.petsFolder.Basic:GetChildren()) do

game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)

end

end

end

end

end)

&#x20;

\-- Sell All Advanced

spawn(function()

while wait(1) do

if Pets.flags.SAdvanced then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game.Players.LocalPlayer.petsFolder.Advanced:GetChildren()) do

game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)

end

end

end

end

end)

&#x20;

\-- Sell All Rares

spawn(function()

while wait(1) do

if Pets.flags.SRare then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game.Players.LocalPlayer.petsFolder.Rare:GetChildren()) do

game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)

end

end

end

end

end)

&#x20;

&#x20;

\-- Sell All Epics

spawn(function()

while wait(1) do

if Pets.flags.SEpic then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game.Players.LocalPlayer.petsFolder.Epic:GetChildren()) do

game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)

end

end

end

end

end)

&#x20;

\-- Sell All Uniques

spawn(function()

while wait(1) do

if Pets.flags.SUnique then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game.Players.LocalPlayer.petsFolder.Unique:GetChildren()) do

game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)

end

end

end

end

end)

&#x20;

\-- Sell All Omegas

spawn(function()

while wait(1) do

if Pets.flags.SOmega then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game.Players.LocalPlayer.petsFolder.Omega:GetChildren()) do

game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)

end

end

end

end

end)

&#x20;

\-- Sell All Elites

spawn(function()

while wait(1) do

if Pets.flags.SElite then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game.Players.LocalPlayer.petsFolder.Elite:GetChildren()) do

game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)

end

end

end

end

end)

&#x20;

&#x20;

\-- Sell All Infinites

spawn(function()

while wait(1) do

if Pets.flags.SInfinity then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game.Players.LocalPlayer.petsFolder.Infinity:GetChildren()) do

game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)

end

end

end

end

end)

&#x20;

\-- Second Pet Stuff Tab

spawn(function()

while wait(1) do

if Pets2.flags.S1 then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game.Players.LocalPlayer.petsFolder.Infinity:GetChildren()) do

if v.Name == "Winter Wonder Kitty" then

game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)

end

end

end

end

end

end)

&#x20;

spawn(function()

while wait(1) do

if Pets2.flags.S2 then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game.Players.LocalPlayer.petsFolder.Infinity:GetChildren()) do

if v.Name == "Winter Legends Polar Bear" then

game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)

end

end

end

end

end

end)

&#x20;

spawn(function()

while wait(1) do

if Pets2.flags.S3 then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game.Players.LocalPlayer.petsFolder.Infinity:GetChildren()) do

if v.Name == "Christmas Sensei Reindeer" then

game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)

end

end

end

end

end

end)

&#x20;

spawn(function()

while wait(1) do

if Pets2.flags.S4 then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game.Players.LocalPlayer.petsFolder.Infinity:GetChildren()) do

if v.Name == "Dark Blizzard Master Penguin" then

game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)

end

end

end

end

end

end)

&#x20;

spawn(function()

while wait(1) do

if Pets2.flags.S5 then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

for i,v in pairs(game.Players.LocalPlayer.petsFolder.Infinity:GetChildren()) do

if v.Name == "Cybernetic Sleigh Rider" then

game.ReplicatedStorage.rEvents.sellPetEvent:FireServer("sellPet", v)

end

end

end

end

end

end)

&#x20;

\-- Fast Shuriken

spawn(function()

while wait(.001) do

if Misc.flags.Fast then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

local plr = game.Players.LocalPlayer

local Mouse = plr:GetMouse()

local velocity = 1000

for \_,p in pairs(game.Workspace.shurikensFolder:GetChildren()) do

if p.Name == "Handle" then

if p:FindFirstChild("BodyVelocity") then

local bv = p:FindFirstChildOfClass("BodyVelocity")

bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)

bv.Velocity = Mouse.Hit.lookVector \* velocity

end

end

end

end

end

end

end)

&#x20;

\-- Slow Shuriken

spawn(function()

while wait(.001) do

if Misc.flags.Slow then

if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then

local plr = game.Players.LocalPlayer

local Mouse = plr:GetMouse()

local velocity = 35

for \_,p in pairs(game.Workspace.shurikensFolder:GetChildren()) do

if p.Name == "Handle" then

if p:FindFirstChild("BodyVelocity") then

local bv = p:FindFirstChildOfClass("BodyVelocity")

bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)

bv.Velocity = Mouse.Hit.lookVector \* velocity

end

end

end

end

end

end

end)

&#x20;

\-- Anti-AFK

local vu = game:GetService("VirtualUser")

game:GetService("Players").LocalPlayer.Idled:connect(

function()

vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)

wait(1)

vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)

end)



\-- Credits

local Credits = library:CreateWindow("Credits")

Credits:Section("- Script Remake By flanut -")

Credits:Label("flanut")

Credits:Label("UI Base: Inori / Ririchi")

Credits:Label("Optimized by: flanut")
