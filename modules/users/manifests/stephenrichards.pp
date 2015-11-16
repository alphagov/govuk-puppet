# Creates the stephenrichards user
class users::stephenrichards {
  govuk::user { 'stephenrichards':
    fullname => 'Stephen Richards',
    email    => 'stephen.richards@digital.cabinet-office.gov.uk',
    ssh_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQChnWeZlGPLjA6aPNGTAh2uwMNuHvcLQA0FQhC6atgRFiOPB3jIWp3gcr7tKuWiFlEFOgMKOFfqi32NHAI4rfWXLpyjy20x+aUZWxTzAepX+/unA/uK+ytxaKmj5++KkXjIMPeEkm03cteR2rkeVEGipbccaLdX5XwieR1jVfZWAGHGaeJFmz40mO10WROxRzA5GwMV+eJGX38Bo4gZvclVGCu2cRkL+xnOyEnBvFcRM59sttuM48qSVbQ0Myxe9LcNNODltD/Tjwzc+hvng+3o1To/TE5rH1bbU8d88NYgbI1iT/WSbmtf/66kqLoS/UJvdDt4EG2qU85aOQZSXAwCjmzcirI4qhItIS2XQW7xPnHsNOQW+fDhrO2jsXFFgLW0wUQ9mSzvAw6puijKcw+PoU2h89UCkSyvIGabtimkhaNET4DgeLhtq6ZTWTJhYMnl9ObcmlEmR73SLnbwFKTn0Swrfyd0n39J5ra9NFPk8JvGQ1uUiMDcBsGqKnvKZnjPCjrpiNeCthOzYWyXAGw/1fAHyWU3660fbXArX51Kge0DSpBv0WaHS8GTppu2vuj+D0/rRja2qtr/2Ah9lBf7GrUPHDIb+uZlotcgx6gxnzoa8lA/1VBeM4+/1PY+S27Oj0VJbMTbl1QuMbgCDsjTICyseDuk4mJCJiPA6DuIsQ== stephen.richards@digital.cabinet-office.gov.uk'
  }
}
