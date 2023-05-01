local sha1 = require("sha1")
local socket = require("socket")
local server = assert(socket.bind("127.0.0.1", 50001))

function hash(password)

	local check = 0
	for i = 1, #password do
		local char = string.sub(password,i,i)
		if not string.find("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ %p", char, 1, true) then
			check=1
			break
		end
	end
	if check ~= 0 then
  		return sha1(password)
	else
		return ""
	end
end


while 1 do
  local client = server:accept()
  client:send("Password: ")
  client:settimeout(60)
  local line, err = client:receive()
  if not err then
      print("trying " .. line) -- log from where ;\
      local h = hash(line)
	if h ~= "" then 
		client:send("CARATTERI NON PERMESSI\n")
	else
      		if h ~= "4754a4f4bd5787accd33de887b9250a0691dd198" then
          		client:send("Better luck next time\n")
          		client:close()
      		else
          		client:send("Congrats, your token is 413**CARRIER LOST**\n")
          		client:close()
      		end
	end
  end
  client:close()
end
