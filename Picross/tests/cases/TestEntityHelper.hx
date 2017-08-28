package cases;

import utest.Assert;

import luxe.Entity;
import luxe.Vector;
import utils.EntityHelper;

class TestEntityHelper
{
    private var parent : Entity;

    public function new() {}

    public function setup()
    {
        parent = new Entity({
            name : 'parent',
            pos : new Vector(10, 10)
        });

        new Entity({
            parent : parent,
            name : 'child1'
        });
    }

    public function testFindChild()
    {
        Assert.notNull(EntityHelper.findChild(parent, 'child1'), 'Failed to find child entity with the name "child1"');
        Assert.isNull (EntityHelper.findChild(parent, 'child2'), 'Found a child with the nane "child2" when there should not be one');
    }

    public function testPointInside()
    {
        Assert.isTrue (EntityHelper.pointInside(new Vector(15, 15), parent.pos, new Vector(10, 10)));
        Assert.isFalse(EntityHelper.pointInside(new Vector(25, 25), parent.pos, new Vector(10, 10)));
    }

    public function teardown()
    {
        parent.destroy();
    }
}
