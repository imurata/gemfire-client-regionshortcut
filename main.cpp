#include <iostream>
#include <thread>
#include <chrono>
#include <geode/CacheFactory.hpp>
#include <geode/CqAttributesFactory.hpp>
#include <geode/PoolManager.hpp>
#include <geode/RegionFactory.hpp>
#include <geode/RegionShortcut.hpp>
#include <geode/Region.hpp>
#include <geode/CacheListener.hpp>
#include <geode/EntryEvent.hpp>
using namespace apache::geode::client;

int main(int argc, char *argv[]) {
    std::string region_name = "PROXY";

    if (argc > 1) {
        region_name = argv[1];
    }
    auto cache = CacheFactory()
            .set("log-level", "none")
            .create();
    auto pool = cache.getPoolManager()
            .createFactory()
            .addLocator("localhost", 10334)
            .setSubscriptionEnabled(true)
            .create("pool");

    //Note: C++ doesn't support string + switch.
    RegionShortcut regionShortcut;
    if(region_name == "PROXY")
        regionShortcut= RegionShortcut::PROXY;
    else if(region_name == "LOCAL")
        regionShortcut = RegionShortcut::LOCAL;
        
    else if(region_name == "CACHING_PROXY")
        regionShortcut = RegionShortcut::CACHING_PROXY;
    else {
        std::cerr << "unknown RegionShortcut: " << region_name << std::endl;
        return 1;
    }
    std::cout << "regionShortcut: " << region_name << std::endl;
    auto regionFactory = cache.createRegionFactory(regionShortcut);
    auto region = regionFactory.create("exampleRegion");

    region->put("1", "one");
    auto aaa = region->get("1");
    std::cout << "key:1 value:" << std::dynamic_pointer_cast<CacheableString>(aaa)->value() << std::endl;
    std::cout << "Sleeping for 60 seconds..." << std::endl;
    std::this_thread::sleep_for(std::chrono::seconds(60));
    std::cout << "Awake after 60 seconds!" << std::endl;
    aaa = region->get("1");
    std::cout << "key:1 value:" << std::dynamic_pointer_cast<CacheableString>(aaa)->value() << std::endl;
    region->put("1", "three");
    
}
