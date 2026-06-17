local m = {
    Frame = function(Instance)
        Instance.BackgroundColor3 = Color3.new(1,1,1);
        Instance.Size = UDim2.fromOffset(100,100);
        Instance.BorderSizePixel = 0;
        Instance.BorderColor3 = Color3.new(0,0,0);
    end;
    BillboardGui = function(Instance)
        Instance.Size = UDim2.fromOffset(100,100);
    end;
    
    
    TextLabel = function(Instance)
        Instance.BackgroundColor3 = Color3.new(1,1,1);
        Instance.Size = UDim2.fromOffset(100,100);
        Instance.BorderSizePixel = 0;Instance.BorderColor3 = Color3.new(0,0,0);
        Instance.Text = "";
    end;
    TextButton = function(Instance)
        Instance.BackgroundColor3 = Color3.new(1,1,1);
        Instance.Size = UDim2.fromOffset(100,100);
        Instance.BorderSizePixel = 0;Instance.BorderColor3 = Color3.new(0,0,0);
        Instance.Text = "";
    end;
    
    
    TextBox = function(Instance)
        Instance.BackgroundColor3 = Color3.new(1,1,1);
        Instance.Size = UDim2.fromOffset(100,100);
        Instance.BorderSizePixel = 0;Instance.BorderColor3 = Color3.new(0,0,0);
        Instance.Text = "";
    end;
    ScrollingFrame = function(Instance)
        Instance.BackgroundColor3 = Color3.new(1,1,1);
        Instance.Size = UDim2.fromOffset(100,100);
        Instance.BorderSizePixel = 0;Instance.BorderColor3 = Color3.new(0,0,0);
        Instance.ScrollBarImageColor3 = Color3.new();
    end;
}

m.VideoFrame = m.Frame;
m.ViewportFrame = m.Frame;
m.ImageLabel = m.Frame
m.ImageButton = m.Frame
m.CanvasGroup = m.Frame
return m