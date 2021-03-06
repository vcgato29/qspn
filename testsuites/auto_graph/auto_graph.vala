/*
 *  This file is part of Netsukuku.
 *  Copyright (C) 2014-2015 Luca Dionisi aka lukisi <luca.dionisi@gmail.com>
 *
 *  Netsukuku is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Netsukuku is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Netsukuku.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gee;
using Test;

errordomain PickAnotherAddressError
{
    GENERIC
}

errordomain PickAnotherNodeError
{
    GENERIC
}

class Test.Address : Object
{
    public ArrayList<int> pos;
    public Address(Gee.List<int> pos)
    {
        this.pos = new ArrayList<int>();
        this.pos.add_all(pos);
    }
    public Address get_common_gnode(Address other)
    {
        ArrayList<int> p = new ArrayList<int>();
        int my_l = pos.size - 1;
        int other_l = other.pos.size - 1;
        while (true)
        {
            if (my_l < 0) break;
            if (other_l < 0) break;
            if (pos[my_l] != other.pos[other_l]) break;
            p.insert(0, pos[my_l]);
            my_l--;
            other_l--;
        }
        return new Address(p);
    }
    public Address get_upper_gnode()
    {
        ArrayList<int> p = new ArrayList<int>();
        for (int l = 1; l < pos.size; l++)
        {
            p.add(pos[l]);
        }
        return new Address(p);
    }
    public string to_string()
    {
        string sep = "";
        string positions = "";
        for (int l = pos.size-1; l >= 0; l--)
        {
            positions += @"$(sep)$(pos[l])";
            sep = ".";
        }
        return @"$(positions)";
    }
}

class Test.Edge : Object
{
    public Test.Node src;
    public Test.Node dst;
}

class Test.Arc : Object
{
    public Node node;
    public int cost;
}

class Test.Node : Object
{
    public Address addr;
    public ArrayList<Arc> arcs;
    public int id;
}

class Test.GNode : Object
{
    public int eldership;
    public HashMap<int, GNode> busy_lst;
    public GNode(int eldership)
    {
        this.eldership = eldership;
        busy_lst = new HashMap<int, GNode>();
    }
}

class GraphBuilder : Object
{
    public GraphBuilder(int[] gsizes, int max_arcs, int num_nodes)
    {
        this.gsizes = gsizes;
        this.max_arcs = max_arcs;
        this.num_nodes = num_nodes;
        levels = gsizes.length;
        edges = new ArrayList<Edge>();
        nodes = new ArrayList<Test.Node>();
        top_gnode = new GNode(0);
    }
    public int[] gsizes;
    public int max_arcs;
    public int num_nodes;
    public int levels;
    public ArrayList<Edge> edges;
    public ArrayList<Test.Node> nodes;
    public GNode top_gnode;
    public void add_node() throws PickAnotherNodeError
    {
        if (nodes.size == 0) {first_node(); return;}
        ArrayList<Test.Node> arcs_n = new ArrayList<Test.Node>();
        int k = 1;
        if (nodes.size < Math.sqrt(num_nodes) * 1.5)
        {
            arcs_n.add(nodes[nodes.size-1]);
        }
        else
        {
            k = Random.int_range(1, 4); // 1..3
            Test.Node v;
            while (true)
            {
                int rnd = Random.int_range(0, nodes.size);
                v = nodes[rnd];
                if (v.arcs.size < max_arcs) break;
            }
            Gee.List<Test.Node> n_v = neighborhood(v, k);
            arcs_n.add(v);
            for (int i = 0; i < k; i++)
            {
                Test.Node v2 = n_v[Random.int_range(0, n_v.size)];
                if (! (v2 in arcs_n) && v2.arcs.size < max_arcs)
                    arcs_n.add(v2);
            }
        }
        Address ref_addr = arcs_n[0].addr;
        Address addr;
        int[] elderships;
        while (true)
        {
            addr = random_addr_to_ref(ref_addr);
            elderships = {};
            Address common = addr.get_common_gnode(ref_addr);
            int levels_common = common.pos.size;
            if (levels_common < levels)
            {
                GNode iteration_gnode = top_gnode;
                int iteration_lev = 0;
                while (iteration_lev < levels_common)
                {
                    elderships += iteration_gnode.busy_lst.size - 1;
                    iteration_gnode = iteration_gnode.busy_lst[common.pos[levels_common-iteration_lev-1]];
                    iteration_lev++;
                }
                if (! (iteration_gnode.busy_lst.has_key(addr.pos[levels-iteration_lev-1])))
                {
                    int next_eldership = iteration_gnode.busy_lst.size;
                    elderships += next_eldership;
                    while (iteration_lev < levels)
                    {
                        int pos = addr.pos[levels-iteration_lev-1];
                        GNode new_gnode = new GNode(next_eldership);
                        iteration_gnode.busy_lst[pos] = new_gnode;
                        iteration_gnode = new_gnode;
                        iteration_lev++;
                        next_eldership = 0;
                        if (iteration_lev < levels) elderships += 0;
                    }
                    break;
                }
            }
        }
        serialization_print("node\n");
        Test.Node n = new Test.Node();
        n.addr = addr;
        n.arcs = new ArrayList<Arc>();
        n.id = nodes.size + 1;
        serialization_print(@"$(n.addr)\n");
        for (int j = 0; j < levels-1; j++)
        {
            serialization_print(@"$(elderships[j]) ");
        }
        serialization_print(@"$(elderships[levels-1])\n");
        foreach (Test.Node q in arcs_n)
        {
            Arc n_to_q = new Arc();
            n_to_q.node = q;
            n_to_q.cost = k*500 + Random.int_range(0, 1000);
            n.arcs.add(n_to_q);
            Arc q_to_n = new Arc();
            q_to_n.node = n;
            q_to_n.cost = k*500 + Random.int_range(0, 1000);
            q.arcs.add(q_to_n);
            Edge nq = new Edge();
            nq.src = n;
            nq.dst = q;
            edges.add(nq);
            serialization_print(@"arc to $(q.addr) cost $(n_to_q.cost) revcost $(q_to_n.cost)\n");
        }
        serialization_print("\n");
        nodes.add(n);
    }
    void first_node()
    {
        serialization_print("topology\n");
        for (int j = levels-1; j > 0; j--)
        {
            serialization_print(@"$(gsizes[j]) ");
        }
        serialization_print(@"$(gsizes[0])\n");
        serialization_print("\n");
        Test.Node n = new Test.Node();
        serialization_print("node\n");
        n.addr = random_addr();
        n.arcs = new ArrayList<Arc>();
        n.id = nodes.size + 1;
        int[] elderships = {};
        GNode iteration_gnode = top_gnode;
        int iteration_lev = 0;
        elderships += 0;
        while (iteration_lev < levels)
        {
            int pos = n.addr.pos[levels-iteration_lev-1];
            GNode new_gnode = new GNode(0);
            iteration_gnode.busy_lst[pos] = new_gnode;
            iteration_gnode = new_gnode;
            iteration_lev++;
            if (iteration_lev < levels) elderships += 0;
        }
        serialization_print(@"$(n.addr)\n");
        for (int j = 0; j < levels-1; j++)
        {
            serialization_print(@"$(elderships[j]) ");
        }
        serialization_print(@"$(elderships[levels-1])\n");
        serialization_print("\n");
        nodes.add(n);
    }
    Address random_addr()
    {
        ArrayList<int> p = new ArrayList<int>();
        for (int i = 0; i < levels; i++) p.add(Random.int_range(0, gsizes[i]));
        return new Address(p);
    }
    Address random_addr_to_ref(Address ref_addr) throws PickAnotherNodeError
    {
        for (int i = 0; i < 100; i++)
        {
            try
            {
                ArrayList<int> p = new ArrayList<int>();
                int iteration_lev = levels-1;
                GNode? iteration_gnode = top_gnode;
                while (iteration_lev >= 0)
                {
                    ArrayList<int> valid_set = new ArrayList<int>();
                    for (int pos = 0; pos < gsizes[iteration_lev]; pos++)
                    {
                        if (iteration_gnode != null && iteration_gnode.busy_lst.has_key(pos)) continue;
                        valid_set.add(pos);
                    }
                    if (iteration_gnode != null && iteration_lev > 0) valid_set.add(ref_addr.pos[iteration_lev]);
                    if (valid_set.is_empty) throw new PickAnotherAddressError.GENERIC("");
                    int c_pos = valid_set[Random.int_range(0, valid_set.size)];
                    p.insert(0, c_pos);
                    iteration_lev--;
                    if (iteration_gnode != null)
                    {
                        if (iteration_gnode.busy_lst.has_key(c_pos))
                            iteration_gnode = iteration_gnode.busy_lst[c_pos];
                        else
                            iteration_gnode = null;
                    }
                }
                Address ret = new Address(p);
                return ret;
            }
            catch (PickAnotherAddressError e) {}
        }
        throw new PickAnotherNodeError.GENERIC("");
    }
    Gee.List<Test.Node> neighborhood(Test.Node v, int k)
    {
        ArrayList<Test.Node> i = new ArrayList<Test.Node>();
        i.add(v);
        return neighborhood_recurse(i, k);
    }
    Gee.List<Test.Node> neighborhood_recurse(Gee.List<Test.Node> v_set, int k)
    {
        if (k == 0) return v_set;
        ArrayList<Test.Node> ret = new ArrayList<Test.Node>();
        ret.add_all(v_set);
        foreach (Test.Node v in v_set)
        {
            foreach (Arc a in v.arcs)
            {
                Test.Node v1 = a.node;
                foreach (Test.Node v2 in neighborhood(v1, k-1))
                {
                    if (! (v2 in ret)) ret.add(v2);
                }
            }
        }
        return ret;
    }

    int base_gnode(int lvl)
    {
        if (lvl == 0) return 0;
        int ret = base_gnode(lvl - 1);
        int num = 1;
        for (int i = lvl - 1; i < levels; i++)
        {
            num *= gsizes[i];
        }
        return ret + num;
    }
    public int id_for_address(Address g)
    {
        int l_o_g = levels - g.pos.size;
        int id = 0;
        for (int i = levels - 1; i >= l_o_g; i--)
        {
            if (i < levels - 1) id *= gsizes[i];
            id += g.pos[i - l_o_g];
        }
        int ret = id + 1 + base_gnode(l_o_g);
        return ret;
    }
}

ArrayList<string> serial;
void serialization_print(string s)
{
    serial.add(s);
}

void output_serialization()
{
    foreach (string s in serial) print(s);
}

void print_graph(GraphBuilder b)
{
    print("GRAPH starts =====\n");
    foreach (Test.Node n in b.nodes)
    {
        print(@"Node $(n.addr)\n");
        if (! n.arcs.is_empty)
        {
            print(" connected to:\n");
            foreach (Arc a in n.arcs)
            {
                print(@"  * $(a.node.addr) (cost = $(a.cost))\n");
            }
        }
    }
    print("GRAPH ends =====\n");
}

void save_gml(GraphBuilder b)
{
    ArrayList<int> nodes_already_written = new ArrayList<int>();
    print("graph [\n");
    foreach (Test.Node n in b.nodes)
    {
        int id = b.id_for_address(n.addr);
        string lbl = @"$(n.addr)";
        int? gid = null;
        Address g_addr = n.addr.get_upper_gnode();
        if (g_addr.pos.size > 0) gid = b.id_for_address(g_addr);
        save_gml_write_node(id, lbl, false, gid);
        nodes_already_written.add(id);
        while (true)
        {
            if (gid == null) break;
            if (gid in nodes_already_written) break;
            id = gid;
            lbl = @"$(g_addr)";
            gid = null;
            g_addr = g_addr.get_upper_gnode();
            if (g_addr.pos.size > 0) gid = b.id_for_address(g_addr);
            save_gml_write_node(id, lbl, true, gid);
            nodes_already_written.add(id);
        }
    }
    foreach (Edge e in b.edges)
    {
        print("  edge [\n");
        print(@"    source $(b.id_for_address(e.src.addr))\n");
        print(@"    target $(b.id_for_address(e.dst.addr))\n");
        print("  ]\n");
    }
    print("]\n");
}

void save_gml_write_node(int id, string lbl, bool is_group, int? gid)
{
    print("  node [\n");
    print(@"    id $(id)\n");
    print(@"    label \"$(lbl)\"\n");
    if (is_group) print(@"    isGroup 1\n");
    if (gid != null) print(@"    gid $(gid)\n");
    print("  ]\n");
}

int num_nodes;
int max_arcs;
[CCode (array_length = false, array_null_terminated = true)]
string[] topology;
bool serialize;
bool savegml;

int main(string[] args)
{
    num_nodes = 50; // default
    max_arcs = 6; // default
    serialize = false; // default
    serial = new ArrayList<string> ();
    savegml = false; // default
    int[] net_topology = {};
    OptionContext oc = new OptionContext();
    OptionEntry[] entries = new OptionEntry[6];
    int index = 0;
    entries[index++] = {"gsize", 's', 0, OptionArg.STRING_ARRAY, ref topology, "Size of gnodes (use it multiple times, one per level starting from lovel 0)", null};
    entries[index++] = {"maxarcs", 'm', 0, OptionArg.INT, ref max_arcs, "Max number of arcs per node", null};
    entries[index++] = {"nodes", 0, 0, OptionArg.INT, ref num_nodes, "Number of nodes", null};
    entries[index++] = {"serialize", 0, 0, OptionArg.NONE, ref serialize, "Produce file to input to tester", null};
    entries[index++] = {"gml", 0, 0, OptionArg.NONE, ref savegml, "Produce GML", null};
    entries[index++] = { null };
    oc.add_main_entries(entries, null);
    try {
        oc.parse(ref args);
    }
    catch (OptionError e) {
        print(@"Error parsing options: $(e.message)\n");
        return 1;
    }

    foreach (string str_size in topology) net_topology += int.parse(str_size);
    if (net_topology.length == 0) net_topology = {16, 8, 8, 8}; // default
    GraphBuilder b = new GraphBuilder(net_topology, max_arcs, num_nodes);
    for (int i = 0; i < num_nodes; i++)
    {
        for (int j = 0; j < 100; j++)
        {
            try {
                b.add_node();
                break;
            } catch (PickAnotherNodeError e) {}
        }
    }
    if (serialize) output_serialization();
    if (savegml) save_gml(b);
    if (! (serialize || savegml)) print_graph(b);
    return 0;
}
