#ifndef SIM_H
#define SIM_H

#ifdef _WINDOWS
#include "Win32DemoApplication.h"
#define PlatformDemoApplication Win32DemoApplication
#else
#include "GlutDemoApplication.h"
#define PlatformDemoApplication GlutDemoApplication
#endif
#include "LinearMath/btAlignedObjectArray.h"
#include "BulletSoftBody/btSoftBody.h"


class btBroadphaseInterface;
class btCollisionShape;
class btOverlappingPairCache;
class btCollisionDispatcher;
class btConstraintSolver;
struct btCollisionAlgorithmCreateFunc;
class btDefaultCollisionConfiguration;

///collisions between two btSoftBody's
class btSoftSoftCollisionAlgorithm;

///collisions between a btSoftBody and a btRigidBody
class btSoftRididCollisionAlgorithm;
class btSoftRigidDynamicsWorld;


///CcdPhysicsDemo shows basic stacking using Bullet physics, and allows toggle of Ccd (using key '1')
class Sim : public PlatformDemoApplication
{
public:

	btAlignedObjectArray<btSoftSoftCollisionAlgorithm*> m_SoftSoftCollisionAlgorithms;

	btAlignedObjectArray<btSoftRididCollisionAlgorithm*> m_SoftRigidCollisionAlgorithms;

	btSoftBodyWorldInfo	m_softBodyWorldInfo;

	

	bool								m_autocam;
	bool								m_cutting;
	bool								m_raycast;
	btScalar							m_animtime;
	btClock								m_clock;
	int									m_lastmousepos[2];
	btVector3							m_impact;
	btSoftBody::sRayCast				m_results;
	btSoftBody::Node*					m_node;
	btVector3							m_goal;
	bool								m_drag;


	//keep the collision shapes, for deletion/cleanup
	btAlignedObjectArray<btCollisionShape*>		m_collisionShapes;

	btBroadphaseInterface*	m_broadphase;

	btCollisionDispatcher*	m_dispatcher;


	btConstraintSolver*	m_solver;

	btCollisionAlgorithmCreateFunc*	m_boxBoxCF;

	btDefaultCollisionConfiguration* m_collisionConfiguration;


public:

	void	initPhysics();

	void	exitPhysics();

	Sim() : m_drag(false)
	{
		setTexturing(true);
		setShadows(true);
	}
	virtual ~Sim()
	{
		exitPhysics();
	}

	virtual void clientMoveAndDisplay();

	virtual void displayCallback();

	void createStack( btCollisionShape* boxShape, float halfCubeSize, int size, float zPos );

	static DemoApplication* Create()
	{
		Sim* demo = new Sim;
		demo->myinit();
		demo->initPhysics();
		return demo;
	}

	virtual	void setDrawClusters(bool drawClusters);

	virtual const btSoftRigidDynamicsWorld*	getSoftDynamicsWorld() const
	{
		///just make it a btSoftRigidDynamicsWorld please
		///or we will add type checking
		return (btSoftRigidDynamicsWorld*) m_dynamicsWorld;
	}

	virtual btSoftRigidDynamicsWorld*	getSoftDynamicsWorld()
	{
		///just make it a btSoftRigidDynamicsWorld please
		///or we will add type checking
		return (btSoftRigidDynamicsWorld*) m_dynamicsWorld;
	}

	//
	void	clientResetScene();
	void	renderme();
	void	keyboardCallback(unsigned char key, int x, int y);
	void	mouseFunc(int button, int state, int x, int y);
	void	mouseMotionFunc(int x,int y);

};

#define MACRO_SIM(a) class Sim##a : public Sim\
{\
public:\
	static DemoApplication* Create()\
	{\
		Sim* demo = new Sim##a;\
		extern int current_demo;\
		current_demo=a;\
		demo->myinit();\
		demo->initPhysics();\
		return demo;\
	}\
};


MACRO_SIM(0) //Init_Cloth
MACRO_SIM(1) //Init_Pressure
MACRO_SIM(2)//Init_Volume
MACRO_SIM(3)//Init_Ropes
MACRO_SIM(4)//Init_Ropes_Attach
MACRO_SIM(5)//Init_ClothAttach
MACRO_SIM(6)//Init_Sticks
MACRO_SIM(7)//Init_Collide
MACRO_SIM(8)//Init_Collide2
MACRO_SIM(9)//Init_Collide3
MACRO_SIM(10)//Init_Impact
MACRO_SIM(11)//Init_Aero
MACRO_SIM(12)//Init_Friction
MACRO_SIM(13)//Init_Torus
MACRO_SIM(14)//Init_TorusMatch
MACRO_SIM(15)//Init_Bunny
MACRO_SIM(16)//Init_BunnyMatch
MACRO_SIM(17)//Init_Cutting1
MACRO_SIM(18)//Init_ClusterDeform
MACRO_SIM(19)//Init_ClusterCollide1
MACRO_SIM(20)//Init_ClusterCollide2
MACRO_SIM(21)//Init_ClusterSocket
MACRO_SIM(22)//Init_ClusterHinge
MACRO_SIM(23)//Init_ClusterCombine
MACRO_SIM(24)//Init_ClusterCar
MACRO_SIM(25)//Init_ClusterRobot
MACRO_SIM(26)//Init_ClusterStackSoft
MACRO_SIM(27)//Init_ClusterStackMixed
MACRO_SIM(28)//Init_TetraCube
MACRO_SIM(29)//Init_TetraBunny


#endif //CCD_PHYSICS_DEMO_H





