for _, package in ipairs(ModularCM.packages) do
    print("Loaded package " .. package)
    Depend(package)
end