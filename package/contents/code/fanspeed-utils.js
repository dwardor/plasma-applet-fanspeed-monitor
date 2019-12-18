function getFanspeedStr(rpmDouble) {
    return Math.round(rpmDouble) + (rpmDouble < 101.0 ? '%' : 'rpm')
}
