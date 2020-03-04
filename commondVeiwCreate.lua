-- -*- coding: UTF-8 -*- 

-- Author:baifu
-- 项目开发和维护阶段中 常需要创建mvc文件（data.lua view.lua ctrl.lua），用于在游戏中创建和更新功能面板，及保存相关数据
-- @该代码用于减少复制粘贴mvc文件 重命名所需要的时间
-- @在ini中配置项目路径

local path_t = require("ini")

local pro = "cq20"
local mvc_name = "zs_vip"
local table_name = "ZsVip"
local child_view = {
    {"hand_compose", "HandCompose"},
    {"hand_add", "HandAdd"},
}

local file_path = path_t[pro].path .. string.format("%s/%s.lua", mvc_name, "%s")
local ui_path = path_t[pro].uipath .. "/%s.lua"
local file_list = {
    {pro .. "view.txt", mvc_name, table_name, file_path, "view"},
    -- {pro .. "subview.txt", child_view[1][1], child_view[1][2], file_path, "view", mvc_name},
    -- {pro .. "subview.txt", child_view[2][1], child_view[2][2], file_path, "view", mvc_name},
    {pro .. "data.txt", mvc_name, table_name, file_path, "data"},
    {pro .. "ctrl.txt", mvc_name, table_name, file_path, "ctrl"},
}

--创建文件夹
os.execute("mkdir ".. path_t[pro].floder_path .. mvc_name)
os.execute("mkdir ".. path_t[pro].respath .. mvc_name)
print("\n" .. path_t[pro].respath .. mvc_name .. "   文件夹创建成功") 
print(path_t[pro].floder_path .. mvc_name .. "   文件夹创建成功") 

local function flie_exit(path)
    local flie = io.open(path, "r")
    if nil ~= flie then flie:close() end
    return nil ~= flie
end
local function createFile(model, mvc_name, table_name, file_path, flie_type_name, base_view_name)
     --创建文件和文件夹
    local flie_name = string.format(file_path, mvc_name .. "_" .. flie_type_name)
    local f = io.open(flie_name, "w")

    --写入内容
    local write_data = ""
    local flie = io.open(model, "r")
    local str = flie:read("*a")
    flie:close()

    if base_view_name then
        str = string.gsub(str, "mvc_name", base_view_name)
    else
        str = string.gsub(str, "mvc_name", mvc_name)
    end

    str = string.gsub(str, "tableName", table_name)
    f:write(str)
    f:close()
end

local function createUiFile()
    --创建文件和文件夹
    local flie_name = string.format(ui_path, mvc_name .. "_ui_cfg.json")
    local f = io.open(flie_name, "w")

    -- 写入内容
    local flie = io.open(pro .. "uicfg.txt", "r")
    local str = flie:read("*a")
    flie:close()
    print("\n" .. flie_name .. "   创建成功\n\n") 
    f:write(str)
    f:close()
end

for i,v in ipairs(file_list) do
    createFile(v[1], v[2], v[3], v[4], v[5], v[6])
end
createUiFile()

if pro == "q3" then
    --模块添加所需代码
    print(string.format("table.insert(self.ctrl_list, %sCtrl.New())", table_name))  
    print(string.format("scripts/game/%s/%s_ctrl", mvc_name, mvc_name))
    print(string.format("%s = \"%s\", -- hello", table_name, table_name))
elseif pro == "cq04" or pro == "cq20" then
    --模块添加所需代码
    print("所需放置文件为 play.lua; require_list.lua; view_def.lua\n") 
    print(string.format("{class = %sCtrl},", table_name))  
    print(string.format("scripts/game/%s/%s_ctrl", mvc_name, mvc_name))
    print(string.format("ViewDef.%s = {name = %q}\n", table_name, table_name))

    print(string.format("提醒组"))
    print(string.format("%s          = %q,", table_name, table_name))
    for i,v in ipairs(child_view) do
        print(string.format("%s          = %q,", v[2], v[2]))
    end 

    print(string.format("%sView      = %q,", table_name, table_name .. "View"))
    print(string.format("[RemindName.%s] = {RemindGroupName.%sView},", table_name, table_name))
    for i,v in ipairs(child_view) do 
        print(string.format("[RemindName.%s] = {RemindGroupName.%sView},", v[2], table_name))
    end
end
