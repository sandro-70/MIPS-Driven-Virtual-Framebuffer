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
        case 10:
        {

            ensure_engine_running();
            return ErrorCode::Ok;
        }
        case 104:
        {
            int a0 = regs[Register::a0];
            return ErrorCode::Ok;
        }
        default:
            return ErrorCode::SyscallNotImplemented;
    }
}
