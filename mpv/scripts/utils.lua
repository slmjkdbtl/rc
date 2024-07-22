local utils = {}

function utils.print(s)
	mp.msg.info(s)
	mp.osd_message(s)
end

return utils
