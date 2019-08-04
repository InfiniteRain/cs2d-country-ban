if not cr then cr = {} end

cr.banned = {
	list = {};

	func = {
		convertTo = function(v)
			local ip = {}
			for match in string.gmatch(v, '[^.]+') do
				table.insert(ip, match)
			end
			return (16777216 * ip[1]) + (65536 * ip[2]) + (256 * ip[3]) + ip[4]
		end;
		
		convertFrom = function(v)
			local a,b,c,d
			a = math.floor(v / 16777216) % 256
			b = math.floor(v / 65536) % 256
			c = math.floor(v / 256) % 256
			d = v % 256
			return a ..'.'.. b ..'.'.. c ..'.'.. d
		end;
		
		getCountry = function(ip)
			local data = {}
			local f = io.open('sys/lua/iptable.csv', 'r')
			for line in f:lines() do
				data = {}
				for match in string.gmatch(line, '[^,]+') do
					table.insert(data, match)
				end
				if cr.banned.func.convertTo(ip) >= tonumber(data[1]) and cr.banned.func.convertTo(ip) <= tonumber(data[2]) then
					return {data[3], data[4]}
				end
			end
			f:close()
			return {'N/A', 'N/A'}
		end;
	};
	
	hook = {
		join = function(id)
			local country = cr.banned.func.getCountry(player(id, 'ip'))[1]
			for k, v in pairs(cr.banned.list) do
				if string.lower(country) == string.lower(v) then
					msg(string.char(169) ..'255255255'.. player(id, 'name') ..'\'s country is banned, kicking...')
					parse('kick '.. id ..' "Your country is banned in this server."')
				end
			end
		end;
	};
}

addhook('join', 'cr.banned.hook.join')