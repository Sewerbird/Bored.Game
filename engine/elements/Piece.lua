local HitBox = require("engine/components/HitBox")
local Animation = require("engine/components/Animation")

local Piece = {}

Piece.__index = Piece

Piece.new = function(player, appearance, width)
  local self = setmetatable({},Piece)
  self.gid = uuid()
  self.is_piece = true
  self.world_x = 0
  self.world_y = 0
  self.width = width
  self.height = height
  self.player = player
  self.dragable = {}
  self.hitbox = HitBox.new(width,width,0,0, 'circle')
  self.appearance = appearance
  self.animation = Animation.new(
    Assets.img[self.appearance],
    {Assets.quad[self.appearance]},
    1/30)
  return self
end

function Piece:draw()
  self.animation:draw(self)
end

function Piece:onClick()
  local src = self.pos_id
  if GS.board.current_player ~= self.player then return false end

  GS.pubsub:subscribe(self.gid,'mouse',function(event,data) 
    if event == 'mousepressed' then 
      self.dragable.active = true
      self.dragable.i_x = self.world_x
      self.dragable.i_y = self.world_y
      if self.animation then
        self.animation:translate(20,-20)
        self.animation:tilt(15)
      end
    elseif event == 'mousemoved' then
      self.world_x = self.world_x + data.dx
      self.world_y = self.world_y + data.dy
    elseif event == 'mousereleased' then
      self.dragable.active = false
      local allowed_to_move = true
      local dst_x, dst_y = self.dragable.i_x, self.dragable.i_y
      for _, tgt in ipairs(GS.scenegraph:worldPxToGobs(self.world_x, self.world_y)) do
        local hops = GS.dice.result
        if tgt ~= self.gid and GS[tgt].is_tile then
          allowed_to_move, enemy_on_square, reason = GS.board:canMovePieceOnto(self.gid,src,GS[tgt].label,hops)
          GS[GS.dialogbox]:show(reason)
          if allowed_to_move then
            if enemy_on_square then GS.board:capturePiece(enemy_on_square, GS[tgt].label) end
            GS.board:movePieceOnto(self.gid,src,GS[tgt].label)
            dst_x = GS[tgt].world_x
            dst_y = GS[tgt].world_y
          elseif tgt ~= self.gid and GS[tgt].is_piece then
            allowed_to_move = false
            dst_x = self.dragable.i_x
            dst_y = self.dragable.i_y
          end
        end
      end
      self.world_x = dst_x
      self.world_y = dst_y
      self.dragable.i_x = nil
      self.dragable.i_y = nil
      if self.animation then
        self.animation:tilt(-15)
        self.animation:translate(-20,20)
      end
      GS.pubsub:unsubscribe(self.gid,'mouse')
    end
  end)

  return true --Absorb
end

return Piece
