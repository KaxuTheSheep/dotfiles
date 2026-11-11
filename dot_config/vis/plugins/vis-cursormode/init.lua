local M = {}

M.styles = {
	normal  = "fore:0,back:7",
	insert  = "fore:7,back:0,underlined",
	replace = "fore:7,back:0,underlined",
}

M.last_mode = nil

function M.update(win)
    local mode = vis.mode
    if mode == M.last_mode then
        return
    end
    M.last_mode = mode

    local style
    if mode == vis.modes.INSERT then
        style = M.styles.insert
    elseif mode == vis.modes.REPLACE then
        style = M.styles.replace
    else
        style = M.styles.normal
    end

    if win then
        vis.ui:style_define(2, style)
        vis.ui:style_define(3, style)
    else
        local current_win = vis.win
        if current_win then
            current_win:style_define(2, style)
            current_win:style_define(3, style)
        end
    end
end

vis.events.subscribe(vis.events.WIN_HIGHLIGHT, M.update)
return M