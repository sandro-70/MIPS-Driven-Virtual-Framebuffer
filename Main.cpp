#include "easm.h"
#include "MipsDisplay.hpp"

static MipsDisplay display;

static bool engine_started = false;

static void ensure_engine_running() {
    if (!engine_started) {
        display.RunEngine();
        engine_started = true;
    }
}

extern "C" ErrorCode handleSyscall(uint32_t *regs, void *mem, MemoryMap *mem_map)
{
    unsigned v0 = regs[Register::v0];

    switch (v0)
    {
        case 30: //correr engine
        {

            ensure_engine_running();
            return ErrorCode::Ok;
        }
        case 31: //isRunning
        {
            regs[Register::v0] = display.IsRunning() ? 1 : 0;
            return ErrorCode::Ok;
        }
        case 100: //Set Pixel
        {
            int x = regs[Register::a0];
            int y = regs[Register::a1];
            uint32_t color = regs[Register::a2];
            
            display.SetPixel(x, y, color);
            
            return ErrorCode::Ok;
            
        }
        case 101: //refresh
        {
            display.Flush();
            return ErrorCode::Ok;
        }
        case 102: //clear
        {
            uint32_t color = regs[Register::a0];

            for(int y = 0; y < display.SCREEN_H; y++){
                for(int x = 0; x < display.SCREEN_W; x++){
                    display.SetPixel(x,y,color);
            }
            }
            return ErrorCode::Ok;
            
            


        }
        case 103: //getKey
        {

        }
        case 104: //sleep
        {
            int a0 = regs[Register::a0];
            return ErrorCode::Ok;
        }
        case 105: //exitGraphics
        {
            display.StopEngine();
            return ErrorCode::Ok;
        }
        default:
            return ErrorCode::SyscallNotImplemented;
    }
}
