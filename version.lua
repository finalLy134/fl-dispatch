local function compareVersions(version1, version2)
  if version1 == version2 then
    return true
  else
    return false
  end
end

local function parseVersion(content)
  return string.match(content, "%d+%.%d+%.%d+")
end

local function base64Decode(data)
  local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  data = string.gsub(data, "[^" .. b .. "=]", "")
  return (data:gsub(".", function(x)
    if (x == "=") then return "" end
    local r, f = "", (b:find(x) - 1)
    for i = 6, 1, -1 do r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0") end
    return r
  end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
    if (#x ~= 8) then return "" end
    local c = 0
    for i = 1, 8 do c = c + (x:sub(i, i) == "1" and 2 ^ (8 - i) or 0) end
    return string.char(c)
  end))
end

local function FetchFileFromGitHub(owner, repo, path, callback)
  local url = ("https://api.github.com/repos/%s/%s/contents/%s"):format(owner, repo, path)

  PerformHttpRequest(url, function(errorCode, resultData, resultHeaders)
    if errorCode == 200 then
      local response = json.decode(resultData)
      local content = base64Decode(response.content)
      callback(content)
    else
      print("Error fetching file:", errorCode)
      callback(nil)
    end
  end)
end

CreateThread(function()
  FetchFileFromGitHub("finalLy134", "fl-dispatch", "version", function(fileContent)
    if fileContent then
      local current = LoadResourceFile(GetCurrentResourceName(), "version")

      if current then
        local currentVersion = parseVersion(current)
        local fileVersion = parseVersion(fileContent)

        if currentVersion and fileVersion and compareVersions(currentVersion, fileVersion) then
          print("FL-Dispatch is up to date! (Version " .. currentVersion .. ")")
        else
          print(
            "FL-Dispatch isn't up to date. Please visit https://github.com/finalLy134/fl-dispatch and install the newer version.")
        end
      else
        print("Failed to open the version file, was it deleted?")
      end
    else
      print(
        "Failed to run a version check, please check if there's an update on https://github.com/finalLy134/fl-dispatch.")
    end
  end)
end)
