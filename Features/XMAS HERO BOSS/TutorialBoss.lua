local ID = 50

BOSS.INIT(ID,"King of Hell Hound");


local function bite(nx,ny,nz,id)
    RUNNER.NEW(function()
        local ex,ey,ez = MYTOOL.GET_DIR_ACTOR(id);
        BOSS.TOOL.ATTACk(id,{x=nx,y=ny,z=nz},{x=3,y=12,z=3},{dmg=25,type=1},{x=ex,y=0.3,z=ez});
        MYTOOL.playSoundOnPos(nx,ny,nz,10162,50,0.5);
        MYTOOL.ADD_EFFECT(nx,ny+1,nz,1182,3);
        RUNNER.NEW(function()
            MYTOOL.DEL_EFFECT(nx,ny+1,nz,1182,3);
        end,{},15);
    end,{},5)
end 


BOSS.ADD_ACTION(ID,function(id)
    local x,y,z = MYTOOL.GET_POS(id); 
    local ex,ey,ez = MYTOOL.GET_DIR_ACTOR(id);
    local nx,ny,nz = x+ex*4,y,z+ez*4;
    bite(nx,ny,nz,id);
end,BOSS.HOOK_Type.OnAttack)